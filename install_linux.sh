#!/usr/bin/env bash
# ==============================================================
# install_linux.sh – Dotfiles installer for Debian / Ubuntu
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

# ── 1. Update package list ────────────────────────────────────
info "Updating package list..."
sudo apt update -y

# ── 2. Install core dependencies ─────────────────────────────
info "Installing core dependencies (git, curl, zsh, neovim, fzf, fd, pipx, rbenv)..."
sudo apt install -y \
  curl \
  git \
  zsh \
  neovim \
  fzf \
  fd-find \
  pipx \
  rbenv

# ── 3. Set zsh as default shell ───────────────────────────────
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  chsh -s "$ZSH_PATH"
else
  info "zsh is already the default shell."
fi

# ── 4. Create fd symlink (Debian installs it as 'fdfind') ─────
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  info "Creating 'fd' symlink for fdfind..."
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
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

# ── 7. Install zoxide ─────────────────────────────────────────
if ! command -v zoxide &>/dev/null; then
  info "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  info "zoxide is already installed."
fi

# ── 8. Install fastfetch ──────────────────────────────────────
if ! command -v fastfetch &>/dev/null; then
  info "Installing fastfetch..."
  if apt-cache show fastfetch &>/dev/null 2>&1; then
    sudo apt install -y fastfetch
  else
    # Download latest .deb from GitHub releases
    ARCH="$(dpkg --print-architecture)"
    FASTFETCH_URL="$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
      | grep "browser_download_url" \
      | grep "linux-${ARCH}.deb" \
      | head -1 \
      | cut -d '"' -f 4)"
    if [ -n "$FASTFETCH_URL" ]; then
      curl -fsSL "$FASTFETCH_URL" -o /tmp/fastfetch.deb
      sudo dpkg -i /tmp/fastfetch.deb
      rm -f /tmp/fastfetch.deb
    else
      warn "Could not find a fastfetch .deb package for ${ARCH}. Skipping."
    fi
  fi
else
  info "fastfetch is already installed."
fi

# ── 9. Install yt-dlp ─────────────────────────────────────────
if ! command -v yt-dlp &>/dev/null; then
  info "Installing yt-dlp via pipx..."
  pipx install yt-dlp
else
  info "yt-dlp is already installed."
fi

# ── 10. Copy .zshrc ───────────────────────────────────────────
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
