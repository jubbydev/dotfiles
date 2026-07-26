# dotfiles

Ghostty + zsh + git config. Catppuccin Mocha theme, Starship prompt, antidote for zsh plugins, fzf/atuin for search, delta for git diffs.

## Setup

```sh
git clone https://github.com/jdeocampo99/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Then install the packages the config expects (also printed by `install.sh`):

```sh
brew install antidote starship fzf atuin git-delta btop fastfetch eza zoxide ripgrep fd bat lazygit tmux direnv
brew install --cask font-jetbrains-mono-nerd-font
```

## Usage

**History / search (atuin)**
- `↑` / `↓` — open atuin's interactive search (replaces plain history cycling)
- `Ctrl+R` — same search, callable mid-line
- Type to fuzzy-filter, `Enter` to run, `Esc` to cancel

**Fuzzy finder (fzf)**
- `Ctrl+T` — fuzzy-find a file/dir under cwd, inserts the path at your cursor. Shows a live preview (bat for files, eza tree for dirs)
- `Alt+C` — fuzzy-find a directory and `cd` into it, with a tree preview
- `**` then `Tab` — fuzzy path completion anywhere a path is expected, e.g. `vim **<Tab>`
- Pipe anything into it yourself, e.g. `git branch | fzf`

**Tab-completion (fzf-tab)**
- Plain `Tab` now opens an fzf-powered menu for *any* completion — file paths, git branches, docker containers, command flags, `brew install <Tab>`, all of it — instead of the old static cycling list. Same bat/eza preview as `Ctrl+T`.

**Prompt (starship)** — shows automatically, nothing to invoke:
- current dir, git branch, git status (`staged`/`modified`/`untracked`/etc. in plain words), language runtime version (only in relevant projects), command duration for anything over 2s

**zsh plugins (antidote)**
- Ghost-text autocomplete as you type — `→` (right arrow) or `End` to accept the suggestion
- Commands are syntax-highlighted live (green = valid, red = typo/invalid) before you hit enter

**File listing (eza aliases)**
- `ls` / `ll` (long) / `la` (long + hidden) / `lt` (tree, 2 levels) / `lta` (tree + hidden)

**Navigation**
- `..` / `...` / `....` — go up 1/2/3 directories
- `z <partial-name>` — zoxide jump straight to a frecent directory (e.g. `z dotfiles`)
- `zi <partial-name>` — same, but opens an fzf picker when there's more than one match instead of guessing

**Per-project env vars (direnv)**
- Drop a `.envrc` in a project dir (e.g. `export API_KEY=...`)
- First time in that dir: `direnv allow` (direnv refuses to auto-load a `.envrc` until you approve it — a safety check against untrusted repos)
- After that, cd'ing in/out of the dir auto-loads/unloads those env vars, no manual `source` needed

**Git**
- `git diff` / `git log -p` — now rendered side-by-side with syntax highlighting via delta
- `git aliases` — prints the full cheatsheet of every alias below, color-coded by category
- Common ones: `git st` (short status), `git cm "msg"` (commit), `git co`/`git cob` (checkout/checkout -b), `git wip` (quick WIP commit), `git lg`/`git ll` (graph log, full/last-20), `git undo`/`git undos` (undo last commit, mixed/soft), `git cmp "msg"` (commit + push in one), `git clean-merged` (delete local branches already merged to main), `git cpbr` (copy current branch name to clipboard)
- `lazygit` — full terminal UI for staging, committing, branching. Tuned for large monorepos: `core.fsmonitor`/`core.untrackedCache` (in `.gitconfig`) make `git status` itself fast instead of rescanning the whole tree every call, and `.config/lazygit/config.yml` disables lazygit's background auto-fetch (still fetches on demand with `f`)

**System monitor**
- `btop` — mouse-driven CPU/mem/disk/net monitor, `q` to quit

**Fun**
- Shows automatically on every new shell (system info banner with OS logo). Run `fastfetch` manually any time too.

**Ghostty**
- `custom-shader` line in `.config/ghostty/config` for CRT/glow effects (not enabled by default)
- `cmd+shift+,` — reload config live after editing
- `` cmd+` `` (backtick) — quick terminal: drop-down terminal that works even when Ghostty isn't the focused app. First reload after adding this, macOS will prompt for Accessibility permission (System Settings → Privacy & Security → Accessibility) — it won't work globally until granted

**herdr** (terminal session/worktree manager, [herdr.dev](https://herdr.dev))
- `prefix+f` / `prefix+shift+f` — open the built-in file viewer (split / tab)
- `prefix+up` / `prefix+down` — herdr-plus: projects / quick actions
- `prefix+u` / `prefix+i` — open the focused branch's GitHub PR in a browser / force a PR-status refresh
- Each workspace's sidebar row shows its branch's PR as `#1127 ✓` — `✓` checks pass, `✗` fail or cancelled, `●` still running, `◆` merged, `⊘` closed, `⟳` recomputing, nothing at all means no PR. Provided by `wyattjoh/herdr-plugin-gh-pr`
- `plugins-local/pr-mirror` is a local plugin of mine: gh-pr labels *panes*, but the spaces sidebar only renders *workspace* tokens, so it copies one onto the other. Without it `$pr` in `[ui.sidebar.spaces]` never resolves
- Quick actions (via herdr-plus) for the Tagalingo repo: delete current worktree, open the branch's Linear ticket, open the branch's GitHub PR
- `tdi/herdr-worktree-setup` runs `./worktree_setup.sh` automatically whenever a new worktree is created for `~/Coding_Projects/tagalog-learning-app`

**LazyVim** (`.config/nvim`)
- Plugins: copilot.lua (GitHub Copilot ghost-text, `Alt+L` to accept), bufferline, treesitter, gitsigns, glance (LSP peek), diffview, snacks
- Custom colorscheme: `ace-palenight`
- See `.config/nvim/CHEATSHEET.md` for the full keymap reference
- First launch after `install.sh` will auto-install plugins via Lazy — expect a delay on first open

## pi coding agent (`pi/`)

Config for the [pi coding agent](https://pi.dev) harness: luna/terra/sol tiered subagents (`pi/agents/`), personal-machine settings (`pi/settings-personal.json`), and the locked-down work-machine settings (`pi/settings-work.json`, no Telegram/MCP/web-access/image-gen). Not wired into `install.sh`; copy into place per machine.

- Work computer: follow `pi/WORK-SETUP.md`. It is written as a runbook an LLM agent can execute directly.
- The `pi-work` alias in `.zshrc` points pi at the locked-down root (`~/.pi/agent-work`).

## Machine-specific / personal config

Not tracked here on purpose — create these yourself on each machine:

- `~/.zshrc.local` — personal aliases, machine-specific PATH entries, secrets/env vars. Sourced automatically by `.zshrc` if present.
- `~/.gitconfig.local` — your `[user]` name/email and any local-only git tool config. Included automatically by `.gitconfig` if present.

Example `~/.gitconfig.local`:

```ini
[user]
	name = Your Name
	email = you@example.com
```
