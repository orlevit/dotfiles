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

Neovim:

![](https://github.com/orlevit/dotfiles/blob/master/images/neovim_demo.gif)

Unix terminal:

![](https://github.com/orlevit/dotfiles/blob/master/images/dotfiles_demo.gif)

## Installation
```
git clone https://github.com/orlevit/dotfiles.git
cd dotfile 
source run.sh
```
### Neovim Usage:
If you using Python, you need that the linter will have a sense of the projet files.
For pylint (the linter), add to project folder a file name ".pylintrc" with:

```
[MASTER]
init-hook = 'import sys; sys.path.append(0, os.getcwd())'
```

Always open nvim in the root directory of the project.

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
- **`yazi`**: Blazing fast terminal file manager written in Rust, based on asynchronous I/O, with built-in previews and plugin support. :contentReference[oaicite:0]{index=0}  
- **`lsd`**: Modern, Rust-powered replacement for `ls` that adds colors, icons, tree view, and extra formatting options. :contentReference[oaicite:1]{index=1}  

#### Nvim Plugins
- **`alpha.lua`**: Start screen with configurable sections.  
- **`catppuccin.lua`**: Catppuccin theme.  
- **`dressing.nvim.lua`**: Enhances `vim.ui.input` and `vim.ui.select` with improved pop-ups.  
- **`indent-blankline.lua`**: Shows indent guides and context.  
- **`lsp-config.lua`**: Sets up built-in LSP servers and diagnostics.  
- **`nvim-tree.lua`**: Sidebar file explorer.  
- **`telescope.lua`**: Fuzzy finder and picker framework.  
- **`vim-easymotion.lua`**: Vim-EasyMotion for quick cursor jumps.  
- **`autopairs.lua`**: Auto-inserts matching brackets, quotes, etc.  
- **`comment.lua`**: Easy comment/uncomment helper.  
- **`formatting.lua`**: Integrates external formatters (e.g., Prettier, Black).  
- **`iron.nvim.lua`**: REPL integration for interactive evaluation.  
- **`lsp-lines.nvim.lua`**: Renders LSP diagnostics as virtual lines.  
- **`nvim-treesitter-context.lua`**: Displays current code context at the top.  
- **`todo-comments.nvim.lua`**: Highlights and navigates TODO/FIXME comments.  
- **`vim-surround.lua`**: Adds, changes, and deletes surrounding delimiters.  
- **`auto-session.lua`**: Automatically saves and restores Neovim sessions.  
- **`completions.lua`**: Autocompletion setup (e.g., nvim-cmp).  
- **`gitsigns.nvim.lua`**: Git change indicators in the sign column.  
- **`lazygit.lua`**: Integrates Lazygit TUI inside Neovim.  
- **`lualine.lua`**: Fast and easy statusline.  
- **`nvim-treesitter-textobjects.lua`**: Treesitter-powered text objects.  
- **`treesitter.lua`**: Core Tree-sitter parsing and highlighting.  
- **`vim-visual-multi.lua`**: Multiple cursors for simultaneous edits.  
- **`bufferline.nvim.lua`**: Buffer/tab line with icons and diagnostics.  
- **`disabled/`**: Directory for configs you’ve disabled.  
- **`image.nvim.lua`**: Inline image previews in buffers.  
- **`linting.lua`**: Linter integration (e.g., nvim-lint).  
- **`substitute.lua`**: Enhanced substitute operations (`:S`-style).  
- **`trouble.lua`**: Pretty diagnostics list and quickfix UI.  
- **`vim.zoom.lua`**: Zooms and restores individual splits.  

## Organization
#### Main directories and files:
- **`bash_scripts`(Directory)**: Bash scripts that responsible for the installation.
- **`dotfiles_to_link`(Directory)**: Dotfiles to link from home directory to the current repository.
- **`.exports` (File)**: Constants for the run.sh script.- 
- **`run.sh` (File)**: The installation script.
