-- Get the path to lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- If it doesn't exist clone it
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
-- Add lazy.nvim to runtimepath
vim.opt.rtp:prepend(lazypath)

-- Add lazy.nvim
require("lazy").setup("plugins")
