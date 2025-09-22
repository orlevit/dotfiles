#!/usr/bin/env bash

source .exports

# ----------------------
# Install Neovim
# ----------------------
mkdir -p $PATH_TO_NVIM_CONFIG
if type -p "nvim" > /dev/null; then
    echo "Neovim already installed" >> "$LOG_FILE"
else
    echo "Installing Neovim 0.11.3 from source" >> "$LOG_FILE"
    sudo apt-get update
    sudo apt-get install -y build-essential cmake gettext
    
    mkdir tmp && cd /tmp
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout v0.11.3
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd ../.. && rm -rf tmp

    if type -p "nvim" > /dev/null; then
        installed_version=$(nvim --version | head -n1)
        echo "Neovim built and installed: $installed_version" >> "$LOG_FILE"
    else
        echo "Neovim installation FAILED!!!" >> "$LOG_FILE"
    fi
fi


# ---------------
# Lazy installation and configuration
# ---------------
source ./bash_scripts/add_to_top_of_file.sh $PATH_TO_NVIM_INIT_CONFIG_FILE "$NVIM_INIT_LAZY_LOC_ADD"
echo "Add location of lazy insatllation that in Additioanl_packages"
