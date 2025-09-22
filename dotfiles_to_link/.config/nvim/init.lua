local lazypath='/home/orlevitas/dev/dotfiles/Additional_packages/lazy.vim'
local lazypath='/home/orlevitas/dev/dotfiles/Additional_packages/lazy.vim'
local lazypath='/home/orlevitas/dev/dotfiles/Additional_packages/lazy.vim'
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core")
require("lazy").setup({{import = "plugins"} , {import = "plugins.lsp"}}, {
  checker = {
    enabled = true,
    notify = false,
  }
})
