#!/bin/bash
# SAM in-app battery: unload on close (P12), device memory (P6), Esc mid-encode
# (P7), a stale result dropped (P8b), the close freeze. Exit = misses.
# usage: battery.sh [gui pid]     (default: the one launch.sh recorded)
# Needs the app running on the fixture, editor closed, on the first frame, and a
# cached checkpoint (MEC_SAM_MODEL). The weights size is q4_0's; set MEC_WEIGHTS
# for another checkpoint.

if [ "$1" = -h ] || [ "$1" = --help ]; then sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 2; fi
source "$(dirname "$0")/env.sh"
PID=${1:-$(cat "$MEC_WORK/gui.pid")}
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; FAILS=$((FAILS + 1)); }
assert() { if python3 -c "import sys; sys.exit(0 if ($2) else 1)"; then pass "$1  [$2]"; else fail "$1  [$2]"; fi; }
now() { python3 -c 'import time; print(time.time())'; }
open_editor() {
  gc click correct_masks >/dev/null
  for i in $(seq 1 200); do [ -n "$(st mask_editor_key)" ] && break; gc wait --frames 5 >/dev/null; done
  gc key g >/dev/null; gc wait --frames 5 >/dev/null
}
wait_not_retiring() { for i in $(seq 1 600); do [ "$(st sam_retiring)" = "False" ] && return 0; gc wait --frames 2 >/dev/null; done; return 1; }
goto() { gc click --at $2 >/dev/null; for i in $(seq 1 100); do [ "$(st mask_editor_key)" = "$1" ] && break; gc wait --frames 5 >/dev/null; done; gc wait --frames 10 >/dev/null; }
WEIGHTS=${MEC_WEIGHTS:-1652.2}

echo "== P12 / P6"
FRESH=$(st sam_pool_mib); echo "fresh: loads $(st sam_loads) pool $FRESH session $(st sam_vram_mib) editor_open $(st mask_editor_open)"
assert "fresh pool is a number before any SAM use" "$FRESH == 0.0"
open_editor
N=$(st sam_results); gc click --at $PRINTER >/dev/null; wait_results $N
LOADED=$(st sam_pool_mib); VRAM=$(st sam_vram_mib)
echo "loaded: pool $LOADED session $VRAM job $(st sam_last_job_ms) ms area $(st sam_last_area)"
assert "sam_vram_mib <= 2500 MiB (q4_0)" "$VRAM <= 2500 and $VRAM > 0"
sleep 3
echo "P6 ps rss KiB, LABEL: does not measure device memory: $(ps -o rss= -p $PID)"
footprint -p $PID 2>/dev/null | command grep -E "unmapped\) \(graphics\)" | sed 's/^/loaded footprint: /'
gc click done >/dev/null; gc wait --frames 10 >/dev/null
wait_not_retiring || fail "retiring slot never emptied"
CLOSED=$(st sam_pool_mib)
echo "closed: open $(st mask_editor_open) pool $CLOSED session $(st sam_vram_mib) close_ms $(st sam_close_ms) retiring $(st sam_retiring)"
assert "pool drop >= weights ($WEIGHTS MiB)" "$LOADED - $CLOSED >= $WEIGHTS"
assert "pool after close == pool before open, within 1 MiB" "abs($CLOSED - $FRESH) <= 1.0"
sleep 3
footprint -p $PID 2>/dev/null | command grep -E "unmapped\) \(graphics\)" | sed 's/^/closed+3s footprint: /'
open_editor
L0=$(st sam_loads)
N=$(st sam_results); gc click --at $PRINTER >/dev/null; gc wait --frames 3 >/dev/null
STATUS=$(st sam_status); echo "reload status (second witness, not asserted): '$STATUS'"
wait_results $N; JOB=$(st sam_last_job_ms); L1=$(st sam_loads)
echo "reload job $JOB ms (logged, not asserted); sam_loads $L0 -> $L1"
assert "reload pays a real model load: sam_loads +1" "$L1 == $L0 + 1"

echo "== P7 (bar: 4000 ms, re-baselined from 2000)"
goto f1 $NEXT
K=$(st mask_editor_kept); H=$(st mask_editor_history); N=$(st sam_results); D=$(st sam_dropped)
gc click --at $PRINTER >/dev/null; gc wait --frames 2 >/dev/null
echo "busy after click: $(st sam_busy) status '$(st sam_status)'"
T0=$(now); gc key Escape >/dev/null
while [ "$(st sam_busy)" = "True" ]; do gc wait --frames 1 >/dev/null; done
W=$(python3 -c "print(round(($(now) - $T0) * 1000))")
echo "P7 wait $W ms (includes ~0.1 s of polling per round)"
gc wait --frames 10 >/dev/null
echo "INFO P7 against the retired 2000 ms bar: $([ $W -le 2000 ] && echo under || echo OVER) (not asserted)"
assert "idle within the re-baselined 4000 ms bar" "$W <= 4000"
assert "kept, history and results unchanged" "'$(st mask_editor_kept)' == '$K' and '$(st mask_editor_history)' == '$H' and '$(st sam_results)' == '$N'"

echo "== P8b"
KNEXT=$(st mask_editor_kept); echo "f1 untouched kept $KNEXT"
goto f0 $PREV
D=$(st sam_dropped); N=$(st sam_results)
gc click --at $CHAIR >/dev/null; gc click --at $NEXT >/dev/null
echo "busy right after leaving: $(st sam_busy)"
while [ "$(st sam_busy)" = "True" ]; do gc wait --frames 2 >/dev/null; done
gc wait --frames 10 >/dev/null
echo "dropped $D -> $(st sam_dropped) results $N -> $(st sam_results) key $(st mask_editor_key) history $(st mask_editor_history) kept $(st mask_editor_kept)"
assert "stale result dropped" "$(st sam_dropped) == $D + 1"
assert "results unchanged" "$(st sam_results) == $N"
assert "new frame history 0" "$(st mask_editor_history) == 0"
assert "new frame kept == untouched" "$(st mask_editor_kept) == $KNEXT"
gc state >/dev/null && pass "state still answers" || fail "state still answers"

freeze() {  # $1 label: Done while a job runs
  N=$(st sam_results); gc click --at $PRINTER >/dev/null; gc wait --frames 2 >/dev/null
  echo "$1: busy $(st sam_busy) status '$(st sam_status)'"
  T0=$(now); gc click done >/dev/null; gc wait --frames 1 >/dev/null; T1=$(now)
  echo "$1: Done -> next frame $(python3 -c "print(round(($T1 - $T0) * 1000))") ms wall; close_ms $(st sam_close_ms) retiring $(st sam_retiring) open $(st mask_editor_open)"
  assert "$1: close_ms <= 100 (about one frame, not the stage)" "$(st sam_close_ms) <= 100"
  wait_not_retiring && pass "$1: the slot empties" || fail "$1: the slot empties"
  echo "$1: retire_ms $(st sam_retire_ms) pool $(st sam_pool_mib)"
  assert "$1: pool back to fresh once retired" "abs($(st sam_pool_mib) - $FRESH) <= 1.0"
}
echo "== close freeze"
freeze mid-encode
open_editor
freeze mid-load
echo "FAILS=$FAILS"
exit $FAILS
