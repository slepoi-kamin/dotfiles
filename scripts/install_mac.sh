#!/usr/bin/env sh

# Get script directory and project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
BREW_FILE="$PROJECT_ROOT/.Brewfile"


# --- Install homebrew ---
if [[ ! -f "/opt/homebrew/bin/brew" ]]; then
  echo "➡️  Installing Homebrew..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew has already been installed."
fi

# --- Install packages ---

if [[ ! -f "$BREW_FILE" ]]; then
  echo "❌ .Brewfile not found in $PROJECT_ROOT"
  exit 1
fi

if ! brew bundle check --no-upgrade -q --file="$BREW_FILE" &>/dev/null; then
    echo "➡️ Installing required packages from Brewfile..."
    brew bundle install --no-upgrade -q --file="$BREW_FILE"
else
  echo "✅ All Brewfile packages are already installed."
fi

