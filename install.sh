#!/usr/bin/env bash
# Symlinks these dotfiles into place. Run from anywhere after cloning this repo.
set -euo pipefail
cd "$(dirname "$0")"
DOTFILES="$(pwd)"

mkdir -p ~/.config/ghostty

ln -sfv "$DOTFILES/.zshrc" ~/.zshrc
ln -sfv "$DOTFILES/.zsh_plugins.txt" ~/.zsh_plugins.txt
ln -sfv "$DOTFILES/.gitconfig" ~/.gitconfig
ln -sfv "$DOTFILES/.config/ghostty/config" ~/.config/ghostty/config
ln -sfv "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

# lazygit reads from ~/Library/Application Support on macOS, not ~/.config
mkdir -p ~/Library/"Application Support"/lazygit
ln -sfv "$DOTFILES/.config/lazygit/config.yml" ~/Library/"Application Support"/lazygit/config.yml

if [ -d "$DOTFILES/.config/nvim" ]; then
	ln -sfv "$DOTFILES/.config/nvim" ~/.config/nvim
fi

# herdr (herdr.dev) — copied, not symlinked, since ~/.config/herdr also holds
# live runtime state (sockets, logs, installed plugin checkouts) alongside config
if [ -d "$DOTFILES/.config/herdr" ]; then
	mkdir -p ~/.config/herdr/plugins/config ~/.config/herdr/plugins/local
	cp -v "$DOTFILES/.config/herdr/config.toml" ~/.config/herdr/config.toml
	cp -rv "$DOTFILES/.config/herdr/plugins-config/." ~/.config/herdr/plugins/config/
	# Locally-authored plugins. Copied like the rest, then linked below.
	cp -rv "$DOTFILES/.config/herdr/plugins-local/." ~/.config/herdr/plugins/local/
fi

# Tern — settings copied, not symlinked, since Tern rewrites settings.json itself.
# Plugins live in ~/Library/Application Support/Tern/plugins; vimnav is vendored here (no upstream).
if [ -d "$DOTFILES/.config/tern" ]; then
	TERN_DIR="$HOME/Library/Application Support/Tern"
	mkdir -p "$TERN_DIR"
	cp -v "$DOTFILES/.config/tern/settings.json" "$TERN_DIR/settings.json"
	if command -v tern >/dev/null 2>&1; then
		tern plugin install "$DOTFILES/.config/tern/plugins/vimnav" --force || echo "tern: vimnav install failed (is Tern running?)"
	fi
fi

# neotern — built from the fork's snacks-picker branch (branch tip at install time; re-run to update).
# Needs a Rust toolchain: brew install rustup && rustup default stable
if command -v cargo >/dev/null 2>&1; then
	cargo install --git https://github.com/jdeocampo99/neotern --branch snacks-picker --root ~/.local --force neotern
else
	echo "neotern: cargo not found; install Rust, then re-run to build neotern from jdeocampo99/neotern@snacks-picker"
fi

echo ""
echo "Symlinked. Now install the packages this config expects:"
echo "  brew install antidote starship fzf atuin git-delta btop fastfetch eza zoxide ripgrep fd bat lazygit tmux"
echo "  brew install --cask font-jetbrains-mono-nerd-font"
echo ""
if [ -d "$DOTFILES/.config/herdr" ]; then
	echo "herdr: install herdr itself (https://herdr.dev/docs/install/), then install the plugins this config uses:"
	echo "  herdr plugin install tdi/herdr-worktree-setup"
	echo "  herdr plugin install cloudmanic/herdr-plus"
	echo "  herdr plugin install wyattjoh/herdr-plugin-gh-pr   # needs herdr >= 0.7.4, bun, gh"
	echo "  herdr plugin link ~/.config/herdr/plugins/local/pr-mirror"
	echo "  herdr plugin link ~/.config/herdr/plugins/local/worktree-cleanup"
	echo "  brew install glow git-delta bat   # renderers used by the built-in file viewer"
	echo "  brew install oven-sh/bun/bun      # gh-pr runs on bun"
	echo ""
fi
echo "If you need machine-specific secrets/env vars, put them in ~/.zshrc.local (gitignored, sourced automatically if present)."
if [ -d "$DOTFILES/.config/tern" ]; then
	echo "tern: install the remaining plugins (keybind alt+shift+z needs worktree):"
	echo "  tern plugin install github.com/nibblebot/tern-worktree"
	echo "  tern plugin install github.com/jubbydev/tern-pr-guide"
	echo "  git clone https://github.com/jdeocampo99/tandem.git ~/Coding_Projects/tandem && tern plugin link ~/Coding_Projects/tandem/tern-plugin"
	echo ""
fi
