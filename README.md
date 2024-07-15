# Dotfiles

Welcome to my dotfiles repository!

**What are Dotfiles?** 

Dotfiles are configuration files for applications and tools that start with a dot (e.g., `.bashrc`, `.vimrc`), these files are often hidden by default on Unix-like systems.

**Why use my Dotfiles?**

Minimalistic, effective, campatabile for bash shell and easy to install!

# Table of contents:
- [Demo](#Demo)
- [Installation](#Installation)
- [Plugins](#Plugins)
- [Organization](#Organization)

# Demo
![](https://github.com/orlevit/dotfiles/blob/master/images/dotfiles_demo.gif)

## Installation
```
git clone https://github.com/orlevit/dotfiles.git
cd dotfile 
source run.sh
```

## Plugins

#### Bash Plugins
- **`Autojump`**: Quickly navigate the filesystem by learning your most frequented directories.
- **`Fzf`**: Command-line fuzzy finder for files, command history, and more.
- **`fzf-git.sh`**: Integrates `Fzf` with git for interactive git commands.
- **`Lazy.vim`**: Simplifies Neovim setup with default configurations and tools.
- **`Tpm`**: Tmux Plugin Manager for easy plugin management in Tmux.

#### Nvim Plugins
- **`alpha.lua`**: Start screen with configurable sections.
- **`catppuccin.lua`**: Catppuccin theme.
- **`completions.lua`**: Autocompletion configuration.
- **`git-stuff.lua`**: Git integration and utilities.
- **`lsp-config.lua`**: Configuration for the built-in Language Server Protocol (LSP).
- **`neo-tree.lua`**: File explorer tree.
- **`none-ls.lua`**: Configures Null LS to use external formatters and linters.
- **`nvim-tmux-navigation.lua`**: Seamless navigation between Neovim and Tmux.
- **`oil.lua`**: Remote file management.
- **`telescope.lua`**: Fuzzy finder and picker.
- **`treesitter.lua`**: Tree-sitter configurations and setup.
- **`vim-test.lua`**: Run tests within the editor.

## Organization

- **`bash_scripts`**: Bash scripts that responsible for the installation.
- **`dotfiles_to_link`**: Dotfiles to link from home directory to the current repository.
- **`.exports`**: Constants for the run.sh script.- 
- **`run.sh`**: The installation script.
