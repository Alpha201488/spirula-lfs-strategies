#!/bin/bash
# The workflow bench dataset: the three 8K root frames mask_doc_test's bench writes
# (f0000..f0002), plus cam1/f0002 copied from f0002 so a second camera exists
# for the cross-camera refusal. Idempotent. Prints the frame count per camera;
# callers assert it rather than assume it.
# usage: [BUILD_DIR=dir] workflow_bench.sh [dir]     (default /tmp/spirula_mask_bench)
# BUILD_DIR defaults to ./build, else the first build_* holding spirula.

D=${1:-/tmp/spirula_mask_bench}
cd "$(dirname "$0")/../.." || exit 1
B=${BUILD_DIR:-}
if [ -z "$B" ]; then
    for d in build build_*; do
        [ -x "$d/spirula" ] && { B=$d; break; }
    done
fi
if [ -z "$B" ] || [ ! -x "$B/mask_doc_test" ]; then
    echo "workflow_bench: no mask_doc_test in '${B:-build, build_*}'; set BUILD_DIR" >&2
    exit 1
fi
if [ ! -f "$D/images/f0002.jpg" ] || [ ! -f "$D/masks/f0002.png" ]; then
    SS_MASK_BENCH="$D" "$B/mask_doc_test" > /dev/null || exit 1
fi
mkdir -p "$D/images/cam1" "$D/masks/cam1"
[ -f "$D/images/cam1/f0002.jpg" ] || cp "$D/images/f0002.jpg" "$D/images/cam1/"
[ -f "$D/masks/cam1/f0002.png" ] || cp "$D/masks/f0002.png" "$D/masks/cam1/"

# A minimal COLMAP text model, so a drop/open of $D routes to the Train
# screen (DatasetPrep.cpp:917-923 needs sparse/ to exist) and actually parses
# (ColmapParser.cpp:693-695: cameras+images are required, points3D is not).
mkdir -p "$D/sparse/0"
cat > "$D/sparse/0/cameras.txt" <<'EOF'
1 PINHOLE 7680 3840 5000 5000 3840 1920
EOF
cat > "$D/sparse/0/images.txt" <<'EOF'
1 1 0 0 0 0 0 0 1 f0000.jpg

2 1 0 0 0 -1 0 0 1 f0001.jpg

3 1 0 0 0 -2 0 0 1 f0002.jpg

4 1 0 0 0 0 -1 0 1 cam1/f0002.jpg

EOF

echo "root $(ls "$D"/images/*.jpg | wc -l | tr -d ' ') cam1 $(ls "$D"/images/cam1/*.jpg | wc -l | tr -d ' ')"
