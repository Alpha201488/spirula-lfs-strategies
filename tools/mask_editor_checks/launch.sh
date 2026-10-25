#!/bin/bash
# Starts the app offscreen, automation on, under env.sh's isolation, and records
# its PID in $MEC_WORK/gui.pid: stop.sh kills that PID and nothing else.
# usage: launch.sh [-n] <spirula binary> <dataset dir> [log name]
#   -n   dry run: print the isolation and the command, start nothing

DRY=0; [ "$1" = -n ] && { DRY=1; shift; }
if [ "$1" = -h ] || [ "$1" = --help ] || [ $# -lt 2 ]; then
    sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 2
fi
source "$(dirname "$0")/env.sh"
LOG=$G/${3:-gui}.log
echo "HOME=$HOME XDG_CONFIG_HOME=$XDG_CONFIG_HOME XDG_CACHE_HOME=$XDG_CACHE_HOME"
echo "models: $(ls "$XDG_CACHE_HOME/spirula-studio/models" 2>/dev/null | tr '\n' ' ')"
echo "gui.conf: $(grep '^native_dialogs=' "$XDG_CONFIG_HOME/spirula-studio/gui.conf")"
echo "launch: $1 --offscreen --port $MEC_PORT -- $2  (log $LOG)"
[ $DRY = 1 ] && exit 0
gc launch --exe "$1" --offscreen --port "$MEC_PORT" --wait 60 --log "$LOG" -- "$2" |
    python3 -c "import json,sys; print(json.load(sys.stdin)['pid'])" > "$MEC_WORK/gui.pid" || exit 1
echo "pid $(cat "$MEC_WORK/gui.pid")"
