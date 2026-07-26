-- Extend blink.cmp's snippet source so custom TS snippets also load for
-- TSX/JS/JSX filetypes. Snippets live in ~/.config/nvim/snippets/*.json.
return {
  {
    "Saghen/blink.cmp",
    opts = {
      -- extended_filetypes belongs to the snippets *source provider*, not to
      -- the top-level `snippets` table (that one only takes preset/expand/
      -- active/jump). Putting it there just prints "Unexpected field in
      -- configuration!" once at startup and drops the setting.
      sources = {
        providers = {
          snippets = {
            opts = {
              extended_filetypes = {
                typescript = { "javascript" },
                typescriptreact = { "typescript", "javascript" },
                javascript = { "typescript" },
                javascriptreact = { "typescript", "javascript" },
              },
            },
          },
        },
      },
    },
  },
}
