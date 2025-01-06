# Dotfiles

Welcome to my dotfiles repository!

**What are Dotfiles?** 

Dotfiles are hidden configuration files for applications and tools that start with a dot (e.g., *.bashrc*, *.vimrc*) on Unix-like systems. 
Additionly, Neovim plugins are installed to provide an IDE-like experience.


**Why use my Dotfiles?**

Minimalistic, effective, compatible with the bash shell and easy to install!

# Table of contents:
- [Demo](#Demo)
- [Installation](#Installation)
- [Plugins](#Plugins)
- [Organization](#Organization)

# Demos
Unix terminal:

![](https://github.com/orlevit/dotfiles/blob/master/images/dotfiles_demo.gif)

Neovim:

![](https://github.com/orlevit/dotfiles/blob/master/images/neovim_demo.gif)

## Installation
```
git clone https://github.com/orlevit/dotfiles.git
cd dotfile 
source run.sh
```

## Plugins

#### Bash Plugins
- **`autojump`**: Quickly navigate the filesystem by learning your most frequented directories.
- **`fzf`**: Command-line fuzzy finder for files, command history, and more.
- **`fzf-git.sh`**: Integrates `Fzf` with git for interactive git commands.
- **`Lazy.vim`**: Simplifies Neovim setup with default configurations and tools.
- **`tpm`**: Tmux Plugin Manager for easy plugin management in Tmux.
- **`git-delta`**: A syntax-highlighting pager for git and diff output to enhance readability.
- **`ripgrep`**: A fast search tool like `grep`, but optimized for recursive search and written in Rust.
- **`bat`**: A `cat` clone with syntax highlighting and Git integration to view file contents in a more readable format.
- **`tldr`**: Simplified and community-driven man pages to provide practical examples for common commands.

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
#### Main directories and files:
- **`bash_scripts`(Directory)**: Bash scripts that responsible for the installation.
- **`dotfiles_to_link`(Directory)**: Dotfiles to link from home directory to the current repository.
- **`.exports` (File)**: Constants for the run.sh script.- 
- **`run.sh` (File)**: The installation script.
