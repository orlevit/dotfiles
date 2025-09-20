#!/bin/bash
# Save as ~/.local/bin/mark-window-rofi.sh

# Get current window ID
window_id=$(xdotool getactivewindow)

# Get mark name from user
mark_name=$(rofi -dmenu -p "Mark window as:")

if [ -n "$mark_name" ]; then
    # Remove existing marks from this window
    i3-msg "[id=$window_id] unmark"
    # Add new mark
    i3-msg "[id=$window_id] mark $mark_name"
    notify-send "Window marked as: $mark_name"
fi
