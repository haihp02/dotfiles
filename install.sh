#!/usr/bin/env bash
set -e

echo "Setting up dotfiles..."

if command -v sudo &> /dev/null; then
  SUDO="sudo"
else
  echo "⚠️ sudo not found. Trying without sudo..."
  SUDO=""
fi

# -----------------------
# Symlinks
# -----------------------
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

# -----------------------
# Install / upgrade Vim
# Requires vim 8+ for native package loading (~/.vim/pack/...) to work.
# -----------------------
install_vim() {
  echo "Installing vim..."
  if command -v apt &> /dev/null; then
    $SUDO apt update
    $SUDO apt install -y vim
  else
    echo "⚠️ apt not found. Please install vim manually."
    exit 1
  fi
}

if ! command -v vim &> /dev/null; then
  install_vim
else
  VIM_MAJOR=$(vim --version | head -1 | grep -oP 'Vi IMproved \K[0-9]+')
  if [ "${VIM_MAJOR:-0}" -lt 8 ]; then
    echo "Vim ${VIM_MAJOR} is too old (need 8+), upgrading..."
    install_vim
  else
    echo "Vim ${VIM_MAJOR} OK — skipping."
  fi
fi

# -----------------------
# Install ripgrep
# -----------------------
if ! command -v rg &> /dev/null; then
  echo "Installing ripgrep..."
  if command -v apt &> /dev/null; then
    $SUDO apt update
    $SUDO apt install -y ripgrep
  else
    echo "⚠️ apt not found. Please install ripgrep manually."
  fi
fi

# -----------------------
# Install fzf (core)
# -----------------------
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

# -----------------------
# Install fzf.vim
# -----------------------
mkdir -p ~/.vim/pack/vendor/start

if [ ! -d "$HOME/.vim/pack/vendor/start/fzf.vim" ]; then
  git clone https://github.com/junegunn/fzf.vim.git \
    ~/.vim/pack/vendor/start/fzf.vim
fi

# -----------------------
# Make sure vim undodir exists
# -----------------------
mkdir -p ~/.vim/undodir

echo "Done."
