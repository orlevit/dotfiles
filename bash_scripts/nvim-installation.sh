#!/usr/bin/env bash

source .exports

# ----------------------
# Install Neovim
# ----------------------

mkdir -p $PATH_TO_NVIM_CONFIG
if type -p "nvim" > /dev/null; then
    echo "Neovim already installed" >> "$LOG_FILE"
else
    sudo apt-get update
    sudo apt-get install neovim -y

    if type -p "nvim" > /dev/null; then
        echo "Neovim installed" >> "$LOG_FILE"
    else
        echo "Neovim installation FAILED!!!" >> "$LOG_FILE"
    fi
fi

# ---------------
# Lazy installation and configuration
# ---------------
source ./bash_scripts/add_to_top_of_file.sh $PATH_TO_NVIM_INIT_CONFIG_FILE "$NVIM_INIT_LAZY_LOC_ADD"
echo "Add location of lazy insatllation that in Additioanl_packages"
