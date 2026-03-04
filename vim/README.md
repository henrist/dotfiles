# Vim setup

This setup uses `vim-plug` and is installed by `vim/install.sh`.

## One-time bootstrap (if needed)

If plugin installation fails, run this manually:

```bash
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Or with wget:

```bash
mkdir -p ~/.vim/autoload
wget -qO ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Plugin commands

Inside Vim:

- `:PlugInstall` install missing plugins
- `:PlugUpdate` update plugins
- `:PlugClean` remove plugins no longer listed

## Install from this repo

From repo root:

```bash
./vim/install.sh
```
