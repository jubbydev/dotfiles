-- Hand-ported from the "Ace Palenight" VS Code theme (acestojanoski.ace-palenight)
-- Source: Ace-Palenight-color-theme.json

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "ace-palenight"

local p = {
  bg = "#282c35",
  bg_dark = "#1c1f26",
  bg_statusline = "#21252B",
  bg_sidebar = "#232830",
  bg_float = "#21252B",
  bg_highlight = "#383E4A",
  bg_visual = "#40485A",
  bg_search = "#314365",
  bg_popup_sel = "#2c313a",
  bg_active_list = "#343d46",

  fg = "#d4d4d4",
  fg_dim = "#bfc7d5",
  fg_statusline = "#9da5b4",
  fg_gutter = "#495162",
  fg_sidebar = "#64727f",

  border = "#181A1F",
  comment = "#697098",
  -- Desaturated teal for editor-generated text (inlay hints). Not from the
  -- upstream VS Code theme; picked for hue separation from code + keywords.
  hint = "#7FA8A3",

  red = "#E15A60",
  pink = "#ff5874",
  rose = "#ff5572",
  orange = "#F78C6C",
  yellow = "#ffcb6b",
  yellow_bright = "#FFEB95",
  green = "#C3E88D",
  ansi_green = "#99C794",
  teal = "#80CBC4",
  cyan = "#89DDFF",
  blue = "#82AAFF",
  blue_dim = "#6699CC",
  indigo = "#7986E7",
  purple = "#c792ea",
  magenta = "#C594C5",
}

local hl = function(name, spec)
  vim.api.nvim_set_hl(0, name, spec)
end

-- Editor UI
hl("Normal", { fg = p.fg, bg = p.bg })
hl("NormalNC", { fg = p.fg, bg = p.bg })
hl("NormalFloat", { fg = p.fg, bg = p.bg_float })
hl("FloatBorder", { fg = p.border, bg = p.bg_float })
hl("FloatTitle", { fg = p.fg_dim, bg = p.bg_float })
hl("Cursor", { fg = p.bg, bg = "#b6bcc4" })
hl("CursorLine", { bg = p.bg_highlight })
hl("CursorLineNr", { fg = p.fg, bold = true })
hl("CursorColumn", { bg = p.bg_highlight })
hl("LineNr", { fg = p.fg_gutter })
hl("SignColumn", { fg = p.fg_gutter, bg = p.bg })
hl("ColorColumn", { bg = p.bg_highlight })
hl("Whitespace", { fg = "#3B4048" })
hl("NonText", { fg = "#3B4048" })
hl("EndOfBuffer", { fg = p.bg })
hl("VertSplit", { fg = p.border })
hl("WinSeparator", { fg = p.border, bg = p.bg })
hl("Folded", { fg = p.fg_sidebar, bg = p.bg_sidebar })
hl("FoldColumn", { fg = p.fg_gutter, bg = p.bg })

hl("StatusLine", { fg = p.fg_statusline, bg = p.bg_statusline })
hl("StatusLineNC", { fg = "#6B717D", bg = p.bg_statusline })
hl("TabLine", { fg = "#6B717D", bg = p.bg_dark })
hl("TabLineSel", { fg = "#dfe1e8", bg = "#2b303b" })
hl("TabLineFill", { bg = p.bg_dark })
hl("WinBar", { fg = p.fg_statusline, bg = p.bg })
hl("WinBarNC", { fg = "#6B717D", bg = p.bg })

hl("Pmenu", { fg = p.fg, bg = p.bg_float })
hl("PmenuSel", { fg = "#c0c5cd", bg = p.bg_popup_sel })
hl("PmenuSbar", { bg = p.bg_float })
hl("PmenuThumb", { bg = p.bg_active_list })
hl("PmenuBorder", { fg = p.border, bg = p.bg_float })

hl("Visual", { bg = p.bg_visual })
hl("VisualNOS", { bg = p.bg_visual })
hl("Search", { bg = p.bg_search, fg = p.fg })
hl("IncSearch", { bg = p.bg_search, fg = p.fg })
hl("CurSearch", { bg = p.bg_search, fg = p.fg })
hl("MatchParen", { bg = "#484e5b", bold = true })

hl("Directory", { fg = "#c0c5cd" })
hl("Title", { fg = p.blue, bold = true })
hl("ModeMsg", { fg = p.fg_dim })
hl("MoreMsg", { fg = p.ansi_green })
hl("Question", { fg = p.ansi_green })
hl("WarningMsg", { fg = p.yellow_bright })
hl("ErrorMsg", { fg = p.red })

-- Diagnostics
hl("DiagnosticError", { fg = p.red })
hl("DiagnosticWarn", { fg = p.yellow_bright })
hl("DiagnosticInfo", { fg = p.blue_dim })
hl("DiagnosticHint", { fg = p.teal })
hl("DiagnosticOk", { fg = p.ansi_green })
hl("DiagnosticUnderlineError", { sp = p.red, underline = true })
hl("DiagnosticUnderlineWarn", { sp = p.yellow_bright, underline = true })
hl("DiagnosticUnderlineInfo", { sp = p.blue_dim, underline = true })
hl("DiagnosticUnderlineHint", { sp = p.teal, underline = true })

-- Inlay hints (parameter names, inferred types). Neovim defaults these to
-- NonText, which is #3B4048 on a #282C35 background — 1.34:1, unreadable.
-- p.hint gives 5.35:1; italic keeps them distinct from real code.
hl("LspInlayHint", { fg = p.hint, italic = true })

-- Snacks picker. A dozen of its groups default-link to NonText (#3B4048),
-- which is 1.48:1 on the #21252B float background — file paths were
-- effectively invisible. Raising NonText itself is wrong (it also draws
-- end-of-buffer markers and listchars), so set the picker groups directly.
-- fg_statusline = 6.2:1, fg_sidebar = 3.1:1 for genuinely de-emphasised rows.
for _, g in ipairs({
  "SnacksPickerDir",
  "SnacksPickerPathHidden",
  "SnacksPickerPathIgnored",
  "SnacksPickerUnselected",
  "SnacksPickerTotals",
  "SnacksPickerBufFlags",
  "SnacksPickerKeymapRhs",
  "SnacksPickerGitStatusIgnored",
  "SnacksPickerGitStatusUntracked",
}) do
  hl(g, { fg = p.fg_statusline })
end
hl("SnacksPickerTree", { fg = p.fg_sidebar })
hl("SnacksPickerCol", { fg = p.fg_sidebar })

-- Diff / git
hl("DiffAdd", { bg = "#1d3b2c" })
hl("DiffChange", { bg = "#233047" })
hl("DiffDelete", { bg = "#3b2229" })
hl("DiffText", { bg = "#314365" })
hl("GitSignsAdd", { fg = p.ansi_green })
hl("GitSignsChange", { fg = p.blue_dim })
hl("GitSignsDelete", { fg = p.red })

-- Base syntax groups
hl("Comment", { fg = p.comment, italic = true })
hl("String", { fg = p.green })
hl("Character", { fg = p.green })
hl("Number", { fg = p.orange })
hl("Float", { fg = p.orange })
hl("Boolean", { fg = p.pink })
hl("Constant", { fg = p.blue })
hl("Identifier", { fg = p.fg_dim })
hl("Function", { fg = p.blue })
hl("Statement", { fg = p.purple })
hl("Conditional", { fg = p.purple })
hl("Repeat", { fg = p.purple })
hl("Label", { fg = p.purple })
hl("Operator", { fg = p.cyan })
hl("Keyword", { fg = p.purple })
hl("Exception", { fg = p.purple })
hl("PreProc", { fg = p.purple })
hl("Include", { fg = p.purple })
hl("Define", { fg = p.purple })
hl("Macro", { fg = p.purple })
hl("Type", { fg = p.yellow })
hl("StorageClass", { fg = p.purple })
hl("Structure", { fg = p.yellow })
hl("Typedef", { fg = p.yellow })
hl("Special", { fg = p.cyan })
hl("SpecialChar", { fg = p.orange })
hl("Tag", { fg = p.rose })
hl("Delimiter", { fg = p.fg_dim })
hl("SpecialComment", { fg = p.comment, italic = true })
hl("Underlined", { underline = true })
hl("Error", { fg = p.red })
hl("Todo", { fg = p.yellow, bold = true })

-- Treesitter / LSP semantic tokens
hl("@comment", { link = "Comment" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = p.orange })
hl("@string.regexp", { fg = p.teal })
hl("@number", { link = "Number" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = p.blue })
hl("@constant.builtin", { fg = p.blue })
hl("@keyword", { fg = p.purple })
hl("@keyword.function", { fg = p.purple })
hl("@keyword.return", { fg = p.purple })
hl("@keyword.operator", { fg = p.purple })
hl("@keyword.import", { fg = p.purple })
hl("@operator", { fg = p.cyan })
hl("@function", { fg = p.blue })
hl("@function.call", { fg = p.blue })
hl("@function.builtin", { fg = p.blue })
hl("@method", { fg = p.blue })
hl("@method.call", { fg = p.blue })
hl("@constructor", { fg = p.yellow })
hl("@variable", { fg = p.fg_dim })
hl("@variable.builtin", { fg = p.rose })
hl("@variable.parameter", { fg = p.indigo })
hl("@variable.member", { fg = p.cyan })
hl("@property", { fg = p.cyan })
hl("@field", { fg = p.cyan })
hl("@type", { fg = p.yellow })
hl("@type.builtin", { fg = p.yellow })
hl("@attribute", { fg = p.yellow })
hl("@namespace", { fg = p.yellow })
hl("@tag", { fg = p.rose })
hl("@tag.attribute", { fg = p.yellow })
hl("@tag.delimiter", { fg = p.cyan })
hl("@punctuation.delimiter", { fg = p.fg_dim })
hl("@punctuation.bracket", { fg = p.fg_dim })
hl("@punctuation.special", { fg = p.cyan })
hl("@markup.heading", { fg = "#82b1ff", bold = true })
hl("@markup.strong", { fg = p.yellow, bold = true })
hl("@markup.italic", { fg = p.purple, italic = true })
hl("@markup.link", { fg = "#ff869a" })
hl("@markup.raw", { fg = p.teal })

-- Common LazyVim UI surfaces
hl("NeoTreeNormal", { fg = p.fg_sidebar, bg = p.bg_sidebar })
hl("NeoTreeNormalNC", { fg = p.fg_sidebar, bg = p.bg_sidebar })
hl("NeoTreeRootName", { fg = "#c0c5cd", bold = true })
hl("SnacksPickerNormal", { fg = p.fg, bg = p.bg_float })
hl("TelescopeNormal", { fg = p.fg, bg = p.bg_float })
hl("TelescopeBorder", { fg = p.border, bg = p.bg_float })
hl("TelescopePromptNormal", { fg = p.fg, bg = p.bg_float })
hl("TelescopeSelection", { bg = p.bg_popup_sel })
hl("BufferLineFill", { bg = p.bg_dark })
hl("WhichKeyFloat", { bg = p.bg_float })
