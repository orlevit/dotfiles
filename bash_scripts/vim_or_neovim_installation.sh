#!/usr/bin/env bash

source .exports

# Prompt user for installation choice
echo "Which editor do you want to install?"
echo "1. Vim"
echo "2. Neovim"
read choice

case $choice in
    1)
        # Call vim-installation.sh script
        source ./bash_scripts/vim-installation.sh
        ;;
    2)
        # Call nvim-installation.sh script
        source ./bash_scripts/nvim-installation.sh
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac
