# P10's scorer; exits non-zero on any miss. Scores the editor's saved mask
# (255 = KEEP) against the operator's hand correction inside p10_roi's box, and
# first checks the file was rewritten by this run and that the null can fail.
# usage: P10_REF=<dir> python p10_score.py <frame> <saved mask png> <md5 before>
import hashlib
import json
import os
import sys

if len(sys.argv) != 4 or sys.argv[1] in ("-h", "--help"):
    sys.exit("usage: P10_REF=<dir> python p10_score.py <frame> <saved mask png> <md5 before>")

import numpy as np  # noqa: E402
from PIL import Image  # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from p10_roi import iou, roi_for  # noqa: E402

Image.MAX_IMAGE_PIXELS = None
f, saved, md5_before = sys.argv[1:4]
fails = []


def check(name, ok, detail):
    print(("PASS " if ok else "FAIL ") + name + "  " + detail)
    if not ok:
        fails.append(name)


md5 = hashlib.md5(open(saved, "rb").read()).hexdigest()
check("saved mask was rewritten by this run", md5 != md5_before, f"{md5_before} -> {md5}")
sam, ref, (x0, y0, x1, y1), stroke, _ = roi_for(f)
ours = np.array(Image.open(saved).convert("L"))
check("saved mask is binary and full size",
      ours.shape == ref.shape and set(np.unique(ours)) <= {0, 255},
      f"{ours.shape} {np.unique(ours)[:4]}")
ours = ours <= 127
s, r, o = sam[y0:y1, x0:x1], ref[y0:y1, x0:x1], ours[y0:y1, x0:x1]
null = iou(s, r)
p10 = iou(o, r)
check("null is computable and nonzero", r.sum() > 0 and 0 < null < 1, f"null {null:.4f}")
check("null leaves room to fail (null < 0.80)", null < 0.80, f"null {null:.4f}")
check("drop-the-whole-ROI cannot pass (< 0.80)", iou(np.ones_like(r), r) < 0.80,
      f"{iou(np.ones_like(r), r):.4f}")
check("click only ADDED drops inside the ROI", not (s & ~o).any(),
      f"sam-dropped px lost: {int((s & ~o).sum())}")
added = int((o & ~s).sum())
check("click added a region inside the ROI", added > 0, f"added {added} px")
extra = o & ~s
inside = int((extra & r).sum())
outside = int((extra & ~r).sum())
print(f"INFO added px inside ref {inside}, outside ref {outside}; "
      f"ref-only px SAM missed {int((r & ~s).sum())}; left undropped {int((r & ~o).sum())}")
print(f"INFO outside-ROI change px {int((ours ^ sam).sum() - (o ^ s).sum())}")
check("SAM add vs hand-painted monopod region >= 0.80", p10 >= 0.80,
      f"IoU {p10:.4f}  (null {null:.4f})")
json.dump(dict(frame=f, box=[x0, y0, x1, y1], null=null, p10=p10, added=added, inside=inside,
               outside=outside, md5=md5), open(f"p10_{f}.json", "w"), indent=1)
print("FAILS=%d %s" % (len(fails), fails))
sys.exit(1 if fails else 0)
