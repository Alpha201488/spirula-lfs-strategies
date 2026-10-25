#!/bin/bash
# Fail when a mask-editor file includes a sam/ header outside #ifdef SS_BUILD_SAM.
#
# mask_doc_test compiles these files without SS_BUILD_SAM, and its nm symbol
# gate only sees what gets linked: an unused sam/ include passes it silently.
# nn/ is deliberately not checked -- app/Pano360.h already reaches nn/io/Image.h.
#
# Usage:  bash tools/check_sam_guard.sh

cd "$(dirname "$0")/.." || exit 1

hits=$(find src/app/gui/mask -type f \( -name '*.h' -o -name '*.cpp' \) -print0 |
    sort -z | xargs -0 awk '
    FNR == 1 { depth = 0 }
    # Each open conditional records whether its CURRENT branch is SAM-only.
    /^[ \t]*#[ \t]*if(def)?[ \t]/ || /^[ \t]*#[ \t]*ifndef[ \t]/ {
        pos = ($0 ~ /^[ \t]*#[ \t]*ifdef[ \t]+SS_BUILD_SAM([^A-Za-z0-9_]|$)/ ||
               $0 ~ /^[ \t]*#[ \t]*if[ \t]+(defined[ \t]*\(?[ \t]*)?SS_BUILD_SAM[ \t]*\)?[ \t]*$/)
        neg = ($0 ~ /^[ \t]*#[ \t]*ifndef[ \t]+SS_BUILD_SAM([^A-Za-z0-9_]|$)/)
        depth++; guard[depth] = pos; flip[depth] = (pos || neg); next
    }
    /^[ \t]*#[ \t]*elif/  { guard[depth] = 0; flip[depth] = 0; next }
    /^[ \t]*#[ \t]*else/  { if (flip[depth]) guard[depth] = !guard[depth]; next }
    /^[ \t]*#[ \t]*endif/ { if (depth > 0) depth--; next }
    /^[ \t]*#[ \t]*include[ \t]*["<]sam\// {
        ok = 0
        for (i = 1; i <= depth; i++) if (guard[i]) ok = 1
        if (!ok) printf "  %s:%d: %s\n", FILENAME, FNR, $0
    }')

if [ -n "$hits" ]; then
    echo "sam/ included outside #ifdef SS_BUILD_SAM in the mask editor:"
    echo ""
    echo "$hits"
    echo ""
    echo "mask_doc_test builds these without the inference layer. Move the include"
    echo "into the SS_BUILD_SAM branch (see MaskSam.cpp)."
    exit 1
fi

echo "OK: no unguarded sam/ include in src/app/gui/mask/."
