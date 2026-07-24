# pi work-machine setup runbook

This runbook is written for an LLM agent to execute on a work-owned computer. It sets up the locked-down pi coding agent harness from this repo. On the work machine the work root is the primary and only config root: no Telegram, no MCP servers, no web-access, no image-gen, no personal SaaS extensions.

Execute the steps in order. Stop and report if a step fails.

## 1. Install pi

```sh
npm install -g @earendil-works/pi-coding-agent
pi --version   # must be >= 0.82.0
```

## 2. Create the work config root

Assumes this dotfiles repo is cloned at `~/dotfiles`.

```sh
mkdir -p ~/.pi/agent-work/agents
cp ~/dotfiles/pi/settings-work.json ~/.pi/agent-work/settings.json
cp ~/dotfiles/pi/agents/luna.md ~/dotfiles/pi/agents/terra.md ~/dotfiles/pi/agents/sol.md ~/.pi/agent-work/agents/
```

Do not copy `settings-personal.json` to this machine; it references personal-stack extensions that must not run on work hardware.

## 3. Point pi at the work root

Two options; on a work-owned machine, prefer option A so every invocation is locked down by default.

**Option A (recommended): make the work root the default.** Add to the shell profile (`~/.zshrc.local` if this repo's zshrc is installed, otherwise `~/.zshrc`):

```sh
export PI_CODING_AGENT_DIR="$HOME/.pi/agent-work"
```

**Option B: alias only.** Keeps `pi` pointing at `~/.pi/agent`, adds a separate command:

```sh
alias pi-work='PI_CODING_AGENT_DIR="$HOME/.pi/agent-work" pi'
```

Open a new shell after either option.

## 4. First run and login

```sh
cd ~ && pi
```

Inside the session run `/login` and authenticate with the provider approved for work use. First startup also auto-installs the packages declared in settings-work.json. Exit after login succeeds.

## 5. Share Claude skills with pi

Pi auto-reads any skills the machine's Claude Code has, via a directory symlink into one of pi's skill scan roots:

```sh
ln -s ~/.claude/skills ~/.pi/agent-work/skills
```

If this machine keeps Claude skills elsewhere, point the symlink at that directory instead.

## 6. Per-project overrides for heavy long-running projects

For projects that load a lot of state up front and need a bigger working set before compaction, drop this in that project's repo root as `.pi/settings.json`:

```json
{
  "observational-memory": { "compactAfterTokens": 180000 }
}
```

Leave the global default at 110000; only override per project.

For each long-running project, keep a distilled `PROJECT-STATE.md` in the repo root and reference it from the project's `AGENTS.md`; instructions files load into the stable system prompt, so that state survives compaction.

## 7. Verify

```sh
cd "$(mktemp -d)"
pi -p "reply with only: ok"                  # expect: ok, no extension load errors
pi -p "Use the luna subagent to say ok"      # expect: ok, proves tier agents are discovered
```

In an interactive session, confirm `/rewind`, `/goal`, and `/om:status` respond, and that the footer shows context usage.

## Warnings (read before deviating)

- Never install the personal-stack extensions on this machine: `@llblab/pi-telegram`, `pi-mcp-adapter`, `pi-web-access`, `pi-codex-image-gen`, `pi-chrome-dev-tools`, `@fink-andreas/pi-linear-tools`, `pi-intercom`, `@guwidoe/pi-clipboard-image`. They forward session content, queries, or prompts to third-party services beyond the model provider.
- Never pin a `model` key inside the `observational-memory` settings block here. Left unset, the memory worker inherits the session's own provider; pinning a different vendor would route every session's content through that second vendor.
- Secrets and machine-specific env vars go in `~/.zshenv` or `~/.zshrc.local` (both untracked), never in tracked config files.
- `~/.pi/agent-work/auth.json` is created by pi on first login and must never be committed anywhere.
