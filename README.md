# dot-files-and-configs

## Terminal

### Kitty
```
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

## Zsh setup

### Oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
```

### Neovim
```
curl -LO --output-dir ~/ https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzf ~/nvim-macos.tar.gz
```

### Powerlevel10k
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```


### fzf

```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### nvm

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
```

### miniconda

Instructions here download the Mac package; adjust this to your installation

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh

bash miniconda.sh -b -p $HOME/miniconda && rm miniconda.sh
```

### bat
```
brew install bat
```

### zsh highlighting
```
brew install zsh-syntax-highlighting
```

### ripgrep
This replaces `grep` and is also used by `fzf` in neovim
```
brew install ripgrep
```

## Additional installations

Check the lsp and null-ls files for neovim. Languages servers and other linters/formatters may be needed

