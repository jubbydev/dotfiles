-- typescript-tools.nvim: a faster, more capable alternative to the default
-- ts_ls/vtsls LSP setup. Provides rename across files, inline type hints,
-- better import organizing, etc. Pairs with plenary.nvim (already installed
-- via LazyVim) and nvim-lspconfig.
--
-- This REPLACES the vtsls server wired by lazyvim.plugins.extras.lang.typescript.
-- We disable that server via the lspconfig `setup` hook (returning true skips
-- lspconfig's own setup) so only typescript-tools attaches to TS/JS buffers.
return {
  -- typescript-tools itself
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lspconfig", "plenary.nvim" },
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    opts = {
      settings = {
        -- inline type hints + source-organize-imports preferences
        tsserver_file_preferences = {
          -- Auto-import via the tsconfig `paths` alias (@/foo) instead of a
          -- relative path. The default, "shortest", picks ../foo whenever that
          -- string is shorter than the alias.
          importModuleSpecifierPreference = "non-relative",
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- disable vtsls so it doesn't race typescript-tools for the same buffers.
  -- `setup.<server>` returning true tells LazyVim's lspconfig config to skip
  -- enabling that server (see LazyVim lua/lazyvim/plugins/lsp/init.lua).
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        vtsls = function()
          return true
        end,
      },
    },
  },
}
