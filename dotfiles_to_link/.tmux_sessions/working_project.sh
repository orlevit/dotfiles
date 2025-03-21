#!/bin/bash

# Get the current working directory
WORKING_DIR="~/dev/invoice_system/invoice"
VENV_LOC="~/dev/invoice_system/llm_env"

# Check if the session already has two panes
if [ "$(tmux list-panes | wc -l)" -lt 2 ]; then
  # Split the window into two panes
  tmux split-window -v
fi

# Configure the first pane: Open nvim in the working directory
tmux select-pane -t 0
VENV_DIR="~/dev/invoice_system/invoice"
tmux send-keys "source ${VENV_LOC}/bin/activate " C-m
tmux send-keys "cd ${WORKING_DIR} && nvim main.py" C-m

# Configure the second pane: Go to the working directory
tmux select-pane -t 1
tmux send-keys "source ${VENV_LOC}/bin/activate " C-m
tmux send-keys "cd ${WORKING_DIR}" C-m

# Return to the first pane (optional)
tmux select-pane -t 0
