#!/bin/bash
# Stops the app launch.sh started, by the PID it recorded, and only if that PID
# is still a spirula process: never a pkill, never another app's window.

source "$(dirname "$0")/env.sh"
PID=$(cat "$MEC_WORK/gui.pid" 2>/dev/null) || { echo "no $MEC_WORK/gui.pid"; exit 1; }
case "$(ps -p "$PID" -o comm= 2>/dev/null)" in
    *spirula*) kill "$PID" && rm -f "$MEC_WORK/gui.pid" && echo "stopped $PID" ;;
    *) echo "pid $PID is not a running spirula; nothing killed"; exit 1 ;;
esac
