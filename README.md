# Dotfiles

Welcome to my dotfiles repository! 
This repository contains various configuration files and scripts (dotfiles) that I use to personalize and configure my development environment across different Unix-based systems.

## What are Dotfiles?

Dotfiles are configuration files for applications and tools that start with a dot (e.g., `.bashrc`, `.vimrc`). These files are often hidden by default on Unix-like systems.

## Why Use Version Control?

Managing dotfiles with Git allows me to track changes over time, synchronize configurations across different machines, and quickly restore settings when needed.

## Organization

- **`.bashrc`**: Configuration for Bash shell.
- **`.vimrc`**: Settings for Vim text editor.
- **`.gitconfig`**: Git configuration.
- **`.functions`**: Custom function.
- **`.ideavimrc`**: Settings for Vim text editor in Pycharm add-on.
- **`.tmux.conf`**: Tmux configuration.
- **`.aliases`**: Aliases configuration.
- **`install-packages.sh`**: Install additional packages
- **`symlinking.sh`**: Creating symbol links to from the original files to the current ones.
- **`i3`**: I3, tiles window manager configuration.

## Installation
```
git clone https://github.com/orlevit/dotfiles.git
cd dotfiles
source install-packages.sh
source symlinking.sh
```
