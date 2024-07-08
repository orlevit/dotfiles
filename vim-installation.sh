#!/usr/bin/env bash

source .exports

# ----------------------
# Install Vim
# ----------------------

if type -p vim >/dev/null; then
    echo "Vim already installed" >> "$LOG_FILE"
else
    echo "Installing Vim..."

    # Update package list and install Vim
    sudo apt-get update
    sudo apt-get install vim -y

    if type -p vim >/dev/null; then
        echo "Vim installed successfully" >> "$LOG_FILE"
    else
        echo "Vim installation FAILED!!!" >> "$LOG_FILE"
    fi
fi

# vim-plug - plugin manager
if [[ -f ~/.vim/autoload/plug.vim ]]; then
    echo "Vim-Plug already installed" >> $LOG_FILE
else
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    if [[ -f ~/.vim/autoload/plug.vim ]]; then
        echo "Vim-Plug Installed" >> $LOG_FILE
    else
        echo "Vim-Plug FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi
