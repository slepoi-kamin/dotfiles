<!-- Context: stow-workflow | Priority: critical | Version: 1.0 | Updated: 2026-03-19 -->

# Stow Workflow

> How to safely modify dotfiles.

## Golden Rule

**Edit in repo → stow → test → commit**

Never edit symlinked files directly in `$HOME`.

## Workflow

### 1. Edit Config

```bash
# Edit the file in the repo
nano ~/.dotfiles/.zshrc  # or open in editor
```

### 2. Apply Changes

```bash
cd ~/.dotfiles
stow .
# or with backup on conflicts
./scripts/safe-stow.sh .
```

### 3. Test

```bash
# Reload shell
source ~/.zshrc

# Or open new terminal
# Test the change
```

### 4. Commit

```bash
git add .
git commit -m "feat: description"
```

---

## Stow Commands

| Command | Action |
|---------|--------|
| `stow .` | Create symlinks |
| `stow -D .` | Delete symlinks |
| `stow -n .` | Dry run |
| `./safe-stow.sh .` | With backup |

---

## Adding New Config

```bash
# 1. Create file in repo
touch ~/.dotfiles/.newconfig

# 2. Stow it
cd ~/.dotfiles && stow .

# 3. File now at ~/.newconfig
```

---

## Safe Stow

`scripts/safe-stow.sh` backs up conflicting files:

```bash
# Normal stow
./scripts/safe-stow.sh .

# Verbose
./scripts/safe-stow.sh -v .

# Simulate first
./scripts/safe-stow.sh -n .
```

Backups saved to `~/.dotfiles_backup_TIMESTAMP/`

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "File exists" error | Run `safe-stow.sh` or manually backup |
| Change not taking effect | `source ~/.zshrc` or restart terminal |
| Broken symlink | `stow -D . && stow .` |
