#!/usr/bin/env bash

set -e

# Get script directory and project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
SAFE_STOW="$PROJECT_ROOT/scripts/safe-stow.sh"

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PACKAGES=(
    stow
    git
    curl
    wget
    zsh

    # Terminal utilities
    bat
    fzf
    htop
    tree
    zoxide

    # Development tools
    make

  )

# Helper function for logging
log() {
  local level="$1"
  local message="$2"
  case "$level" in
    "info")
      echo -e "${BLUE}➡️ ${message}${NC}"
      ;;
    "success")
      echo -e "${GREEN}✅ ${message}${NC}"
      ;;
    "warning")
      echo -e "${YELLOW}⚠️ ${message}${NC}"
      ;;
    "error")
      echo -e "${RED}❌ ${message}${NC}"
      ;;
  esac
}

# --- Install UPT ---
install_upt() {
  if ! command -v upt &> /dev/null; then
    log "info" "Installing UPT (Universal Package-management Tool)..."
    curl -sSf https://raw.githubusercontent.com/sigoden/upt/main/install.sh | sh

    # Add UPT to PATH for this session if it's installed to user's home directory
    if [[ -f "$HOME/.local/bin/upt" ]]; then
      export PATH="$HOME/.local/bin:$PATH"
    fi

    # Verify installation
    if command -v upt &> /dev/null; then
      log "success" "UPT has been installed successfully."
    else
      log "error" "Failed to install UPT. Please install it manually."
      exit 1
    fi
  else
    log "success" "UPT is already installed."
  fi
}

# --- Install essential packages ---
install_packages() {
  log "info" "Installing packages with UPT..."

  for pkg in "${PACKAGES[@]}"; do
    log "info" "installing $pkg ..."
    upt install "$pkg"
  done

  log "success" "Essential packages installed."
}


# --- Main function ---
main() {
  log "info" "Starting Linux dotfiles installation with UPT..."

  # Install UPT
  install_upt

  # Install essential packages
  install_packages
}

# Run main function
main "$@"