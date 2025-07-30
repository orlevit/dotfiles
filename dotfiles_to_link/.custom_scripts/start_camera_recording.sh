#!/bin/bash

source "$HOME/.constants"

FILENAME="recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
FULL_PATH="$BG_VIDEOS_OUT_DIR/$FILENAME"

ffmpeg -f v4l2 -framerate 30 -video_size 1280x720 -i /dev/video0 \
  -f alsa -ar 44100 -ac 2 -i hw:0,0 \
  -c:v libx264 -preset veryfast -crf 23 \
  -c:a aac -b:a 192k \
  -async 1 "$FULL_PATH" > /dev/null 2>&1 &

echo $! > "$HOME/.cam_recording_pid"
echo ")SR("
