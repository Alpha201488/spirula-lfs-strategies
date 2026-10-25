# P10's monopod region and its null. ROI = the bounding box of the largest
# 8-connected component of (operator drop & ~SAM drop), padded by PAD of its own
# size per side. P10_REF names a directory holding masks_eq/<frame>/ and
# masks_eq_edited/<frame>/, each with equirect_mask.png (255 = DROP).
# usage: P10_REF=<dir> python p10_roi.py <frame>...   (writes nulls.json here)
import json
import os
import sys

if __name__ == "__main__" and (len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help")):
    sys.exit("usage: P10_REF=<dir> python p10_roi.py <frame>...")

import numpy as np  # noqa: E402
from PIL import Image  # noqa: E402
from scipy import ndimage  # noqa: E402

Image.MAX_IMAGE_PIXELS = None
PAD = 0.10


def ref_root():
    r = os.environ.get("P10_REF")
    if not r:
        sys.exit("set P10_REF to the directory holding masks_eq/ and masks_eq_edited/")
    return r


def load(p):
    return np.array(Image.open(p).convert("L")) > 127


def roi_for(f):
    r = ref_root()
    sam = load(f"{r}/masks_eq/{f}/equirect_mask.png")
    ref = load(f"{r}/masks_eq_edited/{f}/equirect_mask.png")
    add = ref & ~sam
    lab, n = ndimage.label(add, structure=np.ones((3, 3), bool))
    sizes = ndimage.sum(add, lab, range(1, n + 1))
    k = int(np.argmax(sizes)) + 1
    sl = ndimage.find_objects(lab)[k - 1]
    y0, y1, x0, x1 = sl[0].start, sl[0].stop, sl[1].start, sl[1].stop
    py, px = int((y1 - y0) * PAD), int((x1 - x0) * PAD)
    H, W = ref.shape
    box = (max(0, x0 - px), max(0, y0 - py), min(W, x1 + px), min(H, y1 + py))
    return sam, ref, box, int(sizes[k - 1]), int(n)


def iou(a, b):
    u = (a | b).sum()
    return float((a & b).sum() / u) if u else float("nan")


if __name__ == "__main__":
    out = {}
    for f in sys.argv[1:]:
        sam, ref, (x0, y0, x1, y1), comp, n = roi_for(f)
        s, r = sam[y0:y1, x0:x1], ref[y0:y1, x0:x1]
        d = dict(box=[x0, y0, x1, y1], stroke_px=comp, components=n, ref_px=int(r.sum()),
                 sam_px=int(s.sum()), roi_px=int(r.size), null_unmodified=iou(s, r),
                 null_drop_all=iou(np.ones_like(r), r), null_drop_nothing=iou(np.zeros_like(r), r))
        out[f] = d
        print(f, json.dumps(d))
    json.dump(out, open("nulls.json", "w"), indent=1)
