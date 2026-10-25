#!/bin/bash
# Slideshow memory in the app: resident memory 10 s into playback of an 8K dataset,
# minus the Train-screen baseline, bar 600 MB. One fresh launch per call.
# usage: memory9.sh <arm C|S> <run n> <bench dir> <out dir>
#   C   control: one stroke, then Play      S   SAM loaded and one click first
# S needs MEC_SAM_MODEL (env.sh). Raw readings go to <out dir>/<arm><n>.raw.

ARM=$1; N=$2; BENCH=$3; OUT=$4
case "$ARM" in C|S) ;; *) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;; esac
[ -n "$N" ] && [ -d "$BENCH" ] && [ -n "$OUT" ] || { sed -n '4p' "$0" | sed 's/^# //'; exit 2; }
[ "$ARM" = S ] && [ -z "$MEC_SAM_MODEL" ] && { echo "memory9: arm S needs MEC_SAM_MODEL" >&2; exit 2; }
mkdir -p "$OUT/w$ARM"
OUT=$(cd "$OUT" && pwd); BENCH=$(cd "$BENCH" && pwd)
export MEC_WORK=$OUT/w$ARM
case "$ARM" in C) export MEC_PORT=7931 ;; S) export MEC_PORT=7932 ;; esac
source "$(dirname "$0")/env.sh"
cd "$MEC_TOOLS/../.." || exit 1
RAW=$OUT/$ARM$N.raw
: > "$RAW"

PID() { cat "$MEC_WORK/gui.pid"; }
pri() { ps -o pri= -p "$(PID)" | tr -d ' '; }
rss() { ps -o rss= -p "$(PID)" | awk '{printf "%.0f", $1/1024}'; }
# The centre of the first item a query returns, or of the one with that id.
tree_centre() {
    gc tree -q "$1" --json | python3 -c "import json,sys
its=json.load(sys.stdin); own=[i for i in its if i['id']=='$1']
r=(own or its)[0]['rect']; print('%d,%d'%((r[0]+r[2])/2,(r[1]+r[3])/2))"
}
step() {
    echo "STEP $1 | rss_mb $(rss) | sam_vram_mib $(st sam_vram_mib) | sam_pool_mib $(st sam_pool_mib) | slideshow $(st mask_slideshow) | window $(st mask_slide_window) | threads $(st mask_slide_threads) | pri $(pri) | t $(date +%H:%M:%S)" | tee -a "$RAW"
    vmmap --summary "$(PID)" 2>/dev/null |
        command grep -E "Physical footprint:|MALLOC_LARGE|MALLOC_SMALL|IOAccelerator \(graphics\)|IOSurface|^TOTAL " |
        sed "s/^/  vmmap $1: /" >> "$RAW"
}
field() { command grep "^STEP $1 " "$RAW" | sed "s/.*| $2 \([^ |]*\).*/\1/"; }

[ -f "$MEC_WORK/gui.pid" ] && bash "$MEC_TOOLS/stop.sh" > /dev/null
# App Nap off through the argument domain; the dataset through the in-app folder dialog.
gc launch --exe build/spirula --offscreen --port "$MEC_PORT" --wait 60 --log "$G/gui.log" -- -NSAppSleepDisabled YES |
    python3 -c "import json,sys; print(json.load(sys.stdin)['pid'])" > "$MEC_WORK/gui.pid" || exit 1
gc click home_open_dataset > /dev/null; gc wait --frames 5 > /dev/null
gc text --at "$(tree_centre '##path')" "$BENCH" > /dev/null; gc wait --frames 5 > /dev/null
gc click fd_use_this_folder > /dev/null; gc wait --frames 30 > /dev/null
gc wait --frames 30 > /dev/null; sleep 3
echo "$ARM$N pid $(PID) pri $(pri) screen $(st screen) binary_md5 $(md5 -q build/spirula)" | tee -a "$RAW"
step baseline

gc click correct_masks > /dev/null
for i in $(seq 1 400); do [ -n "$(st mask_editor_key)" ] && break; gc wait --frames 5 > /dev/null; done
gc wait --frames 10 > /dev/null
C=$(tree_centre '##maskcanvas'); gc move --at "$C" > /dev/null; gc wait --frames 10 > /dev/null
step editor_open
if [ "$ARM" = S ]; then
    gc key g > /dev/null; gc wait --frames 5 > /dev/null
    NR=$(st sam_results); gc click --at "$C" > /dev/null; wait_results "$NR"
    wait_idle; gc wait --frames 20 > /dev/null
    echo "$ARM$N sam loads $(st sam_loads) results $(st sam_results)" | tee -a "$RAW"
    step sam_loaded
fi
gc key c > /dev/null; gc wait --frames 3 > /dev/null; H0=$(st mask_editor_history)
gc drag 600,420 900,420 --steps 20 > /dev/null; gc wait --frames 5 > /dev/null
if [ "$(st mask_editor_history)" = "$H0" ]; then
    gc wait --frames 30 > /dev/null; gc drag 600,440 900,440 --steps 20 > /dev/null; gc wait --frames 5 > /dev/null
fi
echo "$ARM$N stroke: history $H0 -> $(st mask_editor_history)" | tee -a "$RAW"
wait_idle
step stroke_done

gc click slide_play > /dev/null; sleep 5
step playing_5s
sleep 5; step playing_10s
sleep 5; step playing_15s
sleep 5; step playing_20s
sleep 10; step playing_30s
sleep 10; step playing_40s
gc key Escape > /dev/null; gc wait --frames 2 > /dev/null; SM=$(st mask_slide_stop_ms)
for i in $(seq 1 200); do
    [ "$(st mask_slideshow)" = False ] && [ -n "$(st mask_editor_key)" ] && [ "$(st mask_editor_history)" != -1 ] && break
    gc wait --frames 3 > /dev/null
done
gc wait --frames 10 > /dev/null
echo "$ARM$N stop_ms $SM join_ms $(st mask_slide_join_ms) key $(st mask_editor_key)" | tee -a "$RAW"
step stopped_frame_open
bash "$MEC_TOOLS/stop.sh" > /dev/null

base=$(field baseline rss_mb); play=$(field playing_10s rss_mb)
vram=$(field playing_10s sam_vram_mib); threads=$(field playing_10s threads)
delta=$((play - base))
if [ "$vram" != -1.0 ]; then
    echo "GATE #9 $ARM$N: sam_vram_mib $vram at 10 s, not -1.0: the SAM session was not released, not a reading" | tee -a "$RAW"
elif [ "$threads" != 2 ]; then
    echo "GATE #9 $ARM$N: threads $threads, not 2: a wrong binary or dataset, not a reading" | tee -a "$RAW"
elif [ "$delta" -le 600 ]; then
    echo "GATE #9 $ARM$N: playing_10s - baseline = $delta MB (bar <= 600) -> PASS" | tee -a "$RAW"
else
    echo "GATE #9 $ARM$N: playing_10s - baseline = $delta MB (bar <= 600) -> MISS" | tee -a "$RAW"
fi
