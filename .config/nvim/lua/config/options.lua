-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- neotern needs a zero-height cmdline: it draws the command line itself.
if vim.g.neotern then
  vim.opt.cmdheight = 0
end
