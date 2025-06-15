
### Installation
install `stow`

```shell
brew install stow
```

Create dotfiles symlinks
```shell
git clone https://github.com/slepoi-kamin/dotfiles.git
cd dotfiles

stow .
```

### Stowing

Create symlinks
```shell
stow .
```

Delete symlinks
```shell
stow -D .
```

Replace conflicting files with files from target dir
```shell
stow --adopt .
```