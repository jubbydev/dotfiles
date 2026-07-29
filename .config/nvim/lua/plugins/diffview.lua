-- ponytail: git plumbing via vim.fn.system, no plenary/job wrapper needed
local function merge_base()
  -- origin/HEAD is the real default branch when it exists; the rest is fallback
  local candidates = { "origin/HEAD", "origin/main", "origin/master", "main", "master" }
  for _, ref in ipairs(candidates) do
    local base = vim.fn.system({ "git", "merge-base", ref, "HEAD" })
    if vim.v.shell_error == 0 then
      return vim.trim(base)
    end
  end
  return nil
end

local function open_branch_diff()
  local base = merge_base()
  if not base then
    return vim.notify("No merge base found (not a git repo, or no main/master)", vim.log.levels.WARN)
  end
  vim.cmd("DiffviewOpen " .. base)
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", open_branch_diff, desc = "Diff View Open (branch vs merge base)" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
      { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Diff View File History" },
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff View Current File History" },
    },
    opts = {},
  },
}
