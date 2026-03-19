# Dotfiles

Reproducible shell environment managed with GNU Stow.

## What This Is

A version-controlled, portable shell setup for macOS/Linux featuring:

- **Zsh** with zinit plugin manager + Powerlevel10k prompt
- **Tmux** with Catppuccin theme and TPM plugins
- **Alacritty** GPU-accelerated terminal
- **Homebrew** package management with Brewfile
- **Safe stow** with auto-backup on conflicts

## Quick Start

### Prerequisites

```bash
# macOS
brew install stow

# Linux
sudo apt install stow  # Debian/Ubuntu
sudo dnf install stow  # Fedora
```

### Fresh Install

```bash
# Clone dotfiles
git clone https://github.com/slepoi-kamin/dotfiles.git
cd dotfiles

# Install Homebrew packages
./scripts/install_mac.sh  # macOS
# or
./scripts/install_linux.sh  # Linux

# Create symlinks
stow .

# Reload shell
source ~/.zshrc
```

## What's Included

| Config | Purpose | Location |
|--------|---------|----------|
| `.zshrc` | Shell config | Zsh + zinit plugins |
| `.tmux.conf` | Terminal multiplexer | Tmux + Catppuccin |
| `.alacritty.toml` | Terminal emulator | GPU-accelerated |
| `.p10k.zsh` | Prompt theme | Powerlevel10k |
| `.Brewfile` | Packages | Homebrew |

## Key Tools

| Tool | Purpose | Docs |
|------|---------|------|
| **stow** | Symlink manager | `man stow` |
| **zinit** | Zsh plugin manager | [zinit docs](https://github.com/zdharma-continuum/zinit) |
| **tmux** | Session manager | `Ctrl+b ?` for help |
| **zoxide** | Smart cd | `z --help` |
| **fzf** | Fuzzy finder | `Ctrl+r` history |

## Common Tasks

### Add a Package

```bash
# Install package
brew install package-name

# Update Brewfile
brew bundle dump --force
```

### Add a Config File

```bash
# Create file in dotfiles/
touch .newconfig

# Stow it
stow .
```

### Safe Stow

The `safe-stow.sh` script auto-backs up conflicting files:

```bash
# Normal stow
./scripts/safe-stow.sh .

# Verbose mode
./scripts/safe-stow.sh -v .

# Simulate first
./scripts/safe-stow.sh -n .

# Delete symlinks
./scripts/safe-stow.sh -D .
```

### Delete Symlinks

```bash
stow -D .
```

## Tmux Quick Reference

| Key | Action |
|-----|--------|
| `Ctrl+f d` | Detach session |
| `Ctrl+f c` | New window |
| `Ctrl+f %` | Split vertical |
| `Ctrl+f "` | Split horizontal |
| `Alt+arrows` | Switch panes |
| `Ctrl+f [` | Copy mode |

## Troubleshooting

**Shell slow?**
- Check `.zshrc` zinit plugin block
- Plugins load async, should be <1s

**Stow conflict?**
- Backups saved to `~/.dotfiles_backup_TIMESTAMP/`
- Restore with `cp -a ~/.dotfiles_backup_*/file ~`

**Tmux broken?**
- Reset: `tmux kill-server`
- Config: `.tmux.conf`

## Documentation

For AI agents and deep dives:

```
.opencode/context/project-intelligence/
├── navigation.md        # Start here
├── technical-domain.md  # Stack & setup
├── decisions-log.md     # Why each tool
├── business-domain.md   # Goals & philosophy
└── living-notes.md      # Current state
```

## License

MIT
