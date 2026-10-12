-- neotern draws the cmdline and messages itself (ext_cmdline), and noice refuses to run next to
-- a UI that does. `g:neotern` is 1 before this config loads when running under neotern.
return {
  { "folke/noice.nvim", cond = not vim.g.neotern },
}
