#!/usr/bin/env python3

import argparse
import os
import re
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm

import cv2
import numpy as np
import OpenEXR
import Imath
import piexif


IMAGE_EXTENSIONS = {
    ".jpg",
    ".jpeg",
    ".png",
    ".bmp",
    ".tif",
    ".tiff",
    ".webp",
    ".jp2",
    ".exr",
}

EXR_EXTENSIONS = {".exr"}
JPEG_EXTENSIONS = {".jpg", ".jpeg"}
# Formats Pillow re-saves losslessly with an EXIF block attached.
PIL_EXIF_EXTENSIONS = {".png", ".tif", ".tiff"}

_FLOAT_PT = Imath.PixelType(Imath.PixelType.FLOAT)

# Imath.PixelType.UINT/HALF/FLOAT are plain ints (0/1/2); use .v to extract
# the value from a PixelType object since it has no __int__ or __hash__.
_PT_TO_DTYPE = {
    0: np.uint32,   # UINT
    1: np.float16,  # HALF
    2: np.float32,  # FLOAT
}


def is_image_file(path: Path) -> bool:
    return path.suffix.lower() in IMAGE_EXTENSIONS


def find_images(root: Path):
    return [
        p
        for p in root.rglob("*")
        if p.is_file() and is_image_file(p)
    ]


def read_exif(path: Path):
    """The source's EXIF as a piexif dict, or None when it carries none."""
    try:
        exif = piexif.load(str(path))
    except Exception:
        try:
            from PIL import Image
            with Image.open(path) as im:
                raw = im.info.get("exif")
            exif = piexif.load(raw) if raw else None
        except Exception:
            exif = None
    if exif and any(exif.get(k) for k in ("0th", "Exif", "GPS", "Interop")):
        return exif
    return None


def exif_bytes_for(exif: dict, w: int, h: int) -> bytes:
    """Serialize `exif` with the pixel-dimension tags rewritten for a w x h image.

    Everything else is copied as is; a tag piexif cannot re-encode is dropped
    rather than losing the whole block.
    """
    exif = {k: (dict(v) if isinstance(v, dict) else v) for k, v in exif.items()}
    zeroth, ex = exif.setdefault("0th", {}), exif.setdefault("Exif", {})
    if piexif.ImageIFD.ImageWidth in zeroth:
        zeroth[piexif.ImageIFD.ImageWidth] = w
    if piexif.ImageIFD.ImageLength in zeroth:
        zeroth[piexif.ImageIFD.ImageLength] = h
    if piexif.ExifIFD.PixelXDimension in ex:
        ex[piexif.ExifIFD.PixelXDimension] = w
    if piexif.ExifIFD.PixelYDimension in ex:
        ex[piexif.ExifIFD.PixelYDimension] = h
    while True:
        try:
            return piexif.dump(exif)
        except ValueError as e:
            # piexif reports an unencodable tag as "<tag> in <ifd> IFD".
            m = re.search(r"(\d+) in (\w+) IFD", str(e))
            if not m or int(m.group(1)) not in exif.get(m.group(2), {}):
                raise
            del exif[m.group(2)][int(m.group(1))]


def attach_exif(dst_path: Path, exif: dict, w: int, h: int, dtype):
    ext = dst_path.suffix.lower()
    if ext in JPEG_EXTENSIONS:
        piexif.insert(exif_bytes_for(exif, w, h), str(dst_path))
    elif ext in PIL_EXIF_EXTENSIONS and dtype == np.uint8:
        # Pillow truncates >8-bit color to 8 bits, hence the dtype guard.
        from PIL import Image
        with Image.open(dst_path) as im:
            im.load()
            im.save(dst_path, exif=exif_bytes_for(exif, w, h))


def read_exr(path: Path):
    """Return (HxWxC float32 array, channel_names, channel_types)."""
    exr = OpenEXR.InputFile(str(path))
    header = exr.header()
    dw = header["dataWindow"]
    w = dw.max.x - dw.min.x + 1
    h = dw.max.y - dw.min.y + 1
    channel_names = sorted(header["channels"].keys())
    channel_types = [header["channels"][name].type for name in channel_names]
    planes = [
        np.frombuffer(exr.channel(name, _FLOAT_PT), dtype=np.float32).reshape(h, w)
        for name in channel_names
    ]
    img = np.stack(planes, axis=-1) if len(planes) > 1 else planes[0][:, :, np.newaxis]
    return img, channel_names, channel_types


def write_exr(path: Path, img: np.ndarray, channel_names: list, channel_types: list):
    path.parent.mkdir(parents=True, exist_ok=True)
    if img.ndim == 2:
        img = img[:, :, np.newaxis]
    h, w = img.shape[:2]
    header = OpenEXR.Header(w, h)
    header["channels"] = {
        name: Imath.Channel(ct) for name, ct in zip(channel_names, channel_types)
    }
    out = OpenEXR.OutputFile(str(path), header)
    out.writePixels({
        name: img[:, :, i].astype(_PT_TO_DTYPE.get(ct.v, np.float32)).tobytes()
        for i, (name, ct) in enumerate(zip(channel_names, channel_types))
    })
    out.close()


def save_image(dst_path: Path, image, jpeg_quality: int,
               exr_channels=None, exr_types=None, exif=None):
    dst_path.parent.mkdir(parents=True, exist_ok=True)
    ext = dst_path.suffix.lower()
    if ext in EXR_EXTENSIONS:
        write_exr(dst_path, image, exr_channels, exr_types)
        return
    if ext in JPEG_EXTENSIONS:
        cv2.imwrite(str(dst_path), image, [cv2.IMWRITE_JPEG_QUALITY, jpeg_quality])
    else:
        cv2.imwrite(str(dst_path), image)
    if exif is not None:
        h, w = image.shape[:2]
        attach_exif(dst_path, exif, w, h, image.dtype)


def process_image(
    src_path: Path,
    src_root: Path,
    dst_roots: dict,
    scales: list,
    jpeg_quality: int,
):
    try:
        ext = src_path.suffix.lower()
        exr_channels = exr_types = None
        exif = None

        if ext in EXR_EXTENSIONS:
            img, exr_channels, exr_types = read_exr(src_path)
        else:
            # IMREAD_UNCHANGED leaves the pixels in stored orientation, so the
            # EXIF Orientation tag stays valid for the copies.
            img = cv2.imread(str(src_path), cv2.IMREAD_UNCHANGED)
            if img is None:
                print(f"Failed to read: {src_path}")
                return
            exif = read_exif(src_path)

        orig_h, orig_w = img.shape[:2]
        rel_path = src_path.relative_to(src_root)

        # Cascade: each level downscales from the previous level.
        # Target size is always derived from original to avoid rounding drift.
        sorted_scales = sorted(scales)
        prev_img = img
        for scale in sorted_scales:
            new_w = max(1, orig_w // scale)
            new_h = max(1, orig_h // scale)
            resized = cv2.resize(prev_img, (new_w, new_h), interpolation=cv2.INTER_AREA)
            dst_path = dst_roots[scale] / rel_path
            save_image(dst_path, resized, jpeg_quality, exr_channels, exr_types, exif)
            prev_img = resized

    except Exception as e:
        print(f"Error processing {src_path}: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Generate downscaled image pyramids, carrying EXIF over."
    )

    parser.add_argument("work_folder", type=Path)
    parser.add_argument("--images-dir", default="images")
    parser.add_argument("--scales", type=int, nargs="+", default=[2, 4, 8])
    parser.add_argument("--jpeg-quality", type=int, default=95)
    parser.add_argument("--threads", type=int, default=os.cpu_count())

    args = parser.parse_args()

    work_folder = args.work_folder.resolve()
    src_root = work_folder / args.images_dir

    if not src_root.is_dir():
        raise RuntimeError(f"Source folder not found: {src_root}")

    images = find_images(src_root)
    print(f"Found {len(images)} images.")

    dst_roots = {
        scale: work_folder / f"{args.images_dir}_{scale}"
        for scale in args.scales
    }

    # Prevent nested threading
    cv2.setNumThreads(1)

    with ThreadPoolExecutor(max_workers=args.threads) as executor:
        for _ in tqdm(
            executor.map(
                lambda p: process_image(p, src_root, dst_roots, args.scales, args.jpeg_quality),
                images,
            ),
            total=len(images),
            desc="Processing images",
        ):
            pass

    print("Done.")


if __name__ == "__main__":
    main()
