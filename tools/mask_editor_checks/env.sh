# Sourced by every script here (macOS: they use md5 and footprint). Isolates the
# app from the operator's own settings, cache and models before anything runs.
#   MEC_WORK       scratch dir for the run; HOME and XDG_* move under it (required)
#   MEC_SAM_MODEL  a checkpoint to link into the scratch cache; its file name must
#                  be the catalog's, e.g. sam3-q4_0.ggml (optional)
#   MEC_PORT       automation port (default 7893)
# Screen points below are for the 1600x950 offscreen window and the 360 photo
# fixture (15520x7760); override them for any other dataset.

MEC_TOOLS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [ -z "$MEC_ISOLATED" ]; then
    [ -n "$MEC_WORK" ] || { echo "env.sh: set MEC_WORK to a scratch directory" >&2; exit 2; }
    [ "$(cd "$MEC_WORK" 2>/dev/null && pwd)" != "$(cd "$HOME" && pwd)" ] ||
        { echo "env.sh: MEC_WORK must not be your HOME" >&2; exit 2; }
    G=$MEC_WORK/gui
    mkdir -p "$G/home" "$G/cfg/spirula-studio" "$G/cache/spirula-studio/models"
    export HOME=$G/home XDG_CONFIG_HOME=$G/cfg XDG_CACHE_HOME=$G/cache MEC_ISOLATED=1
    conf=$G/cfg/spirula-studio/gui.conf
    if [ -f "$conf" ]; then sed -i '' 's/^native_dialogs=.*/native_dialogs=0/' "$conf"
    else echo "native_dialogs=0" > "$conf"; fi
    if [ -n "$MEC_SAM_MODEL" ]; then
        ln -sf "$MEC_SAM_MODEL" "$G/cache/spirula-studio/models/$(basename "$MEC_SAM_MODEL")"
    fi
fi
T=$MEC_WORK
G=$MEC_WORK/gui
MEC_PORT=${MEC_PORT:-7893}
PREV=${MEC_PREV:-16,74}; NEXT=${MEC_NEXT:-311,74}
PRINTER=${MEC_PRINTER:-470,330}; CHAIR=${MEC_CHAIR:-945,310}

gc() { python3 "$MEC_TOOLS/../guictl.py" "$@"; }
st() { gc state | python3 -c "import json,sys; print(json.load(sys.stdin)['$1'])"; }
wait_results() { for i in $(seq 1 900); do [ "$(st sam_results)" -gt "$1" ] && return 0; gc wait --frames 2 >/dev/null; done; return 1; }
wait_idle() { for i in $(seq 1 600); do [ "$(st sam_busy)" = "False" ] && return 0; gc wait --frames 1 >/dev/null; done; return 1; }
