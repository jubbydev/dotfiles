-- MiniPairs.cr() expands `{|}` into an indented block on Enter, but it decides
-- by looking at the two characters immediately around the cursor. That misses
-- two cases:
--   1. JSX tags   -- `<div>|</div>` is `>` then `<`, not a registered pair
--   2. stray space -- `{ |}` (type `{`, then a space) reads as ` }` and falls
--      back to a plain <CR>, leaving the closing brace stuck on the cursor line
-- Both are handled here by scanning past whitespace; everything else defers to
-- MiniPairs untouched.
local CLOSER = { ["("] = ")", ["["] = "]", ["{"] = "}" }

return {
  "nvim-mini/mini.pairs",
  config = function(_, opts)
    LazyVim.mini.pairs(opts)

    vim.keymap.set("i", "<CR>", function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.fn.col(".")
      local before, after = line:sub(1, col - 1), line:sub(col)

      local b = before:match("(%S)%s*$")
      local a = after:match("^%s*(%S)")
      local jsx = b == ">" and a == "<"
      local bracket = b ~= nil and CLOSER[b] == a

      if not (jsx or bracket) then
        return MiniPairs.cr()
      end

      local pad_left = #before:match("%s*$")
      local pad_right = #after:match("^%s*")
      -- Nothing to clean up and MiniPairs already knows this pair, so let it run.
      if bracket and pad_left == 0 and pad_right == 0 then
        return MiniPairs.cr()
      end

      -- `O` only inherits the opening tag's own indent (indentexpr is
      -- GetTypescriptIndent, which can't infer depth from an empty line), so
      -- <C-t> adds the one level JSX always wants. Brackets don't need it —
      -- indentexpr already understands them. <Tab> would hit blink.cmp.
      local keys = string.rep("<BS>", pad_left)
        .. string.rep("<Del>", pad_right)
        .. "<CR><Esc>O"
        .. (jsx and "<C-t>" or "")
      return vim.api.nvim_replace_termcodes(keys, true, false, true)
    end, { expr = true, replace_keycodes = false, desc = "Expand pairs and JSX tags on CR" })
  end,
}
