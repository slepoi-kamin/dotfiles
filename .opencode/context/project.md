<!-- Context: project | Priority: critical | Version: 1.0 | Updated: 2026-03-19 -->

# Project: Dotfiles

> Reproducible shell environment managed with GNU Stow.

## Identity

- **Type**: Dotfiles (shell configuration repo)
- **Purpose**: Portable, version-controlled shell setup
- **Manager**: GNU Stow (symlink-based)
- **Target**: macOS workstations

## What Gets Stowed

Everything in repo root → symlinks in `$HOME`:
- `.zshrc`, `.tmux.conf`, `.p10k.zsh`
- `.alacritty.toml`, `.Brewfile`
- `.opencode/` (AI context)

## What Is NOT Stowed

```
.git/           # Git data
.idea/          # IDE settings
scripts/        # Install scripts (run manually)
README.md       # Documentation
.install.sh     # Entry point
.tmp/           # Session files
```

## Goals

1. Reproducible environment on any machine
2. Single command setup (`./install_mac.sh && stow .`)
3. Version-controlled configuration
4. AI agent context for working with dotfiles

## Key Files

| File | Purpose |
|------|---------|
| `.zshrc` | Zsh + zinit plugin manager |
| `.tmux.conf` | Tmux + Catppuccin theme |
| `.Brewfile` | Homebrew package list |
| `scripts/install_mac.sh` | Initial setup |
| `scripts/safe-stow.sh` | Safe stow with backup |
