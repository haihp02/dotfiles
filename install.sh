#!/usr/bin/env bash
set -e

echo "Setting up dotfiles..."

# -----------------------
# Check sudo availability
# -----------------------
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

echo "Done."

