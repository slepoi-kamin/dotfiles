#!/usr/bin/env bash

echo "🔧 Setting up..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect platform
if [[ "$(uname)" == "Darwin" ]]; then
  PLATFORM="mac"
  echo "🍎 Detected macOS system"
elif [[ "$(uname)" == "Linux" ]]; then
  PLATFORM="linux"
  echo "🐧 Detected Linux system"
else
  echo "❌ Unsupported platform: $(uname)"
  exit 1
fi


if [[ "$PLATFORM" == "mac" ]]; then
  echo "➡️ Running macOS setup script..."
  sh "$SCRIPT_DIR/scripts/install_mac.sh"

elif [[ "$PLATFORM" == "linux" ]]; then
  # Detect Linux distribution
  echo "➡️ Running Linux setup script..."
  "$SCRIPT_DIR/scripts/install_linux.sh"
fi

# Make safe-stow executable
chmod +x "$SCRIPT_DIR/scripts/safe-stow.sh"

echo "➡️ Creating dotfile symlinks..."
"$SCRIPT_DIR/scripts/safe-stow.sh" .

echo "✅ Setup completed successfully!"