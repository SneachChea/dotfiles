#!/usr/bin/env bash
# ==============================================================
# install_macos.sh – Dotfiles installer for macOS
# ==============================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ── 1. Install Homebrew ───────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  info "Homebrew is already installed."
fi

# ── 2. Update Homebrew ────────────────────────────────────────
info "Updating Homebrew..."
brew update

# ── 3. Install zsh ───────────────────────────────────────────
if ! brew list zsh &>/dev/null; then
  info "Installing zsh..."
  brew install zsh
else
  info "zsh is already installed."
fi

# ── 4. Set zsh as default shell ───────────────────────────────
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  # Add Homebrew's zsh to /etc/shells if not already there
  if ! grep -qF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
  chsh -s "$ZSH_PATH"
else
  info "zsh is already the default shell."
fi

# ── 5. Install oh-my-zsh ──────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  info "oh-my-zsh is already installed."
fi

# ── 6. Install zsh custom plugins ────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  info "zsh-autosuggestions already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  info "zsh-syntax-highlighting already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  info "Installing zsh-completions..."
  git clone https://github.com/zsh-users/zsh-completions \
    "$ZSH_CUSTOM/plugins/zsh-completions"
else
  info "zsh-completions already installed."
fi

# ── 7. Install CLI tools via Homebrew ─────────────────────────
info "Installing CLI tools (neovim, fzf, fd, zoxide, fastfetch, yt-dlp, rbenv, pipx)..."
brew install \
  neovim \
  fzf \
  fd \
  zoxide \
  fastfetch \
  yt-dlp \
  rbenv \
  pipx

# Enable fzf shell bindings and completions
info "Setting up fzf shell integration..."
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

# ── 8. Copy .zshrc ───────────────────────────────────────────
info "Installing .zshrc..."
if [ -f "$HOME/.zshrc" ]; then
  BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
  warn "Backing up existing .zshrc to $BACKUP"
  cp "$HOME/.zshrc" "$BACKUP"
fi
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
info "Done! .zshrc installed at $HOME/.zshrc"

echo
info "======================================================"
info " Installation complete!"
info " Please log out and back in (or run: exec zsh)"
info " to start using your new shell configuration."
info "======================================================"
echo
warn "NOTE: The .zshrc contains some hardcoded paths (miniconda,"
warn "      rbenv, pipx) that you may need to update manually."
