#!/bin/bash

if [ -f "$HOME/.cam_recording_pid" ]; then
    PID=$(cat "$HOME/.cam_recording_pid")
    if ps -p $PID > /dev/null 2>&1; then
        kill "$PID"
    fi
    rm "$HOME/.cam_recording_pid"
fi
echo "(SR)"
