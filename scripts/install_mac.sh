#!/usr/bin/env sh

echo "🔧 Setting up..."

# --- Install homebrew ---
if [[ ! -f "/opt/homebrew/bin/brew" ]] then
  echo "➡️  Installing Homebrew..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew has already been installed."
fi

# --- Install packages ---
echo "➡️  Installing required packages ..."

echo "➡️  Installing stow ..."
brew install stow
echo "➡️  Installing fzf ..."
brew install fzf
echo "➡️  Installing zoxide ..."
brew install zoxide

echo "➡️  Installing fonts ..."
brew install --cask font-fira-code-nerd-font font-jetbrains-mono-nerd-font

