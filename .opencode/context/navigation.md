<!-- Context: navigation | Priority: critical | Version: 1.0 | Updated: 2026-03-19 -->

# Dotfiles Project Context

> Quick navigation for AI agents. Start here.

## What Is This Project?

**Dotfiles repo** managed by GNU Stow. Contains shell configs, terminal settings, and development tools. Gets symlinked to `$HOME`.

## Project Structure

```
.dotfiles/                    # This repo (stowed to ~)
├── .zshrc                   # Zsh config + zinit plugins
├── .tmux.conf               # Tmux config
├── .p10k.zsh                # Powerlevel10k prompt
├── .alacritty.toml          # Alacritty terminal
├── .Brewfile                # Homebrew packages
├── scripts/                  # Install scripts (NOT stowed)
└── .opencode/               # AI agent context (IS stowed)
```

## Quick Routes

| Need | File |
|------|------|
| What this is | `project.md` |
| Installed tools | `tech-stack.md` |
| Config patterns | `config-patterns.md` |
| How to modify | `stow-workflow.md` |

## Key Principles

- **Stow-managed**: Everything in root symlinked to `~`
- **Safe modifications**: Use `safe-stow.sh` script
- **Test locally**: Edit → stow → test → commit

## Related

- `~/.opencode/context/` (symlink destination)
- `.config/opencode/` (global OAC instructions - NOT project-specific)
