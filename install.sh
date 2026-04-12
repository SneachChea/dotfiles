#!/usr/bin/env bash
# ==============================================================
# install.sh – Dotfiles installer entry point
# Detects the OS and delegates to the appropriate script.
# ==============================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Linux)
    info "Detected Linux – running Linux installer..."
    bash "$DOTFILES_DIR/install_linux.sh"
    ;;
  Darwin)
    info "Detected macOS – running macOS installer..."
    bash "$DOTFILES_DIR/install_macos.sh"
    ;;
  *)
    error "Unsupported operating system: $(uname -s)"
    ;;
esac
