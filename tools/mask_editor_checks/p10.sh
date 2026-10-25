#!/bin/bash
# P10, SAM on a monopod: one click, Save, then score the saved mask.
# usage: p10.sh <frame key> <screen x,y> <frame x> <frame y>
# The app must be running (launch.sh) on MEC_DATASET with the editor open on
# that frame in SAM mode. P10_REF: see p10_roi.py. Needs uv (pillow, numpy,
# scipy). Points used for the recorded runs: points_ext.txt.

if [ "$1" = -h ] || [ "$1" = --help ] || [ $# -ne 4 ]; then
    sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 2
fi
source "$(dirname "$0")/env.sh"
[ -n "$MEC_DATASET" ] && [ -n "$P10_REF" ] || { echo "set MEC_DATASET and P10_REF"; exit 2; }
cd "$MEC_WORK" || exit 2
KEY=$1; AT=$2; FX=$3; FY=$4; FAILS=0
MASK=$MEC_DATASET/masks/$KEY.png
[ "$(st mask_editor_key)" = "$KEY" ] || { echo "FAIL editor is on $(st mask_editor_key), not $KEY"; exit 1; }
M0=$(md5 -q "$MASK"); N=$(st sam_results)
gc click --at "$AT" >/dev/null; wait_results "$N" || { echo "FAIL no SAM result"; exit 1; }
gc wait --frames 10 >/dev/null
gc state > "state_$KEY.json"
python3 - "$FX" "$FY" "state_$KEY.json" <<'PY' || FAILS=$((FAILS+1))
import json, sys
fx, fy = map(float, sys.argv[1:3])
d = json.load(open(sys.argv[3]))
cx, cy = d["sam_click"]
print("click frame px", cx, cy, "job ms", d["sam_last_job_ms"], "area", d["sam_last_area"],
      "dets", d["sam_last_detections"], "score", d["sam_last_score"], "kept",
      d["mask_editor_kept"], "history", d["mask_editor_history"], "err", repr(d["sam_error"]))
ok = abs(cx - fx) <= 60 and abs(cy - fy) <= 60 and d["sam_error"] == "" and d["sam_last_area"] > 0
print(("PASS" if ok else "FAIL") + " click landed within 60 px of the intended pole point, no error, nonzero area")
sys.exit(0 if ok else 1)
PY
gc shot "$G/after_$KEY.png" --width 1600 >/dev/null
gc click save >/dev/null
for i in $(seq 1 300); do [ "$(md5 -q "$MASK")" != "$M0" ] && break; gc wait --frames 5 >/dev/null; done
uv run --with pillow --with numpy --with scipy python "$MEC_TOOLS/p10_score.py" "$KEY" "$MASK" "$M0" ||
    FAILS=$((FAILS+1))
echo "p10.sh FAILS=$FAILS"; exit $FAILS
