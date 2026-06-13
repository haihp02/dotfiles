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
# Pick editor: vim or neovim
# -----------------------
EDITOR_CHOICE=""
while [[ "$EDITOR_CHOICE" != "vim" && "$EDITOR_CHOICE" != "nvim" ]]; do
  read -rp "Which editor do you want to set up? [vim/nvim]: " EDITOR_CHOICE
done

# -----------------------
# Symlinks
# -----------------------
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

if [ "$EDITOR_CHOICE" = "vim" ]; then
  ln -sf ~/dotfiles/vimrc ~/.vimrc
else
  mkdir -p ~/.config
  ln -sfn ~/dotfiles/nvim ~/.config/nvim
fi

# -----------------------
# Install tmux 3.6a from official prebuilt binary
# -----------------------
TMUX_VERSION="3.6a"
if ! command -v tmux &> /dev/null || [ "$(tmux -V | grep -oP '\d+\.\d+')" \< "3.3" ]; then
  echo "Installing tmux ${TMUX_VERSION}..."
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  TMUX_ARCH="linux-x86_64" ;;
    aarch64) TMUX_ARCH="linux-arm64" ;;
    *)       echo "⚠️ Unsupported architecture: $ARCH. Please install tmux manually." && exit 1 ;;
  esac
  curl -sLo /tmp/tmux.tar.gz "https://github.com/tmux/tmux-builds/releases/download/v${TMUX_VERSION}/tmux-${TMUX_VERSION}-${TMUX_ARCH}.tar.gz"
  tar -xzf /tmp/tmux.tar.gz -C /tmp
  $SUDO mv /tmp/tmux /usr/local/bin/tmux
  hash -r
  rm -f /tmp/tmux.tar.gz
  echo "tmux $(tmux -V) installed."
else
  echo "tmux $(tmux -V) OK — skipping."
fi

if [ "$EDITOR_CHOICE" = "vim" ]; then
  # -----------------------
  # Install / upgrade Vim
  # Requires vim 9+ for native package loading (~/.vim/pack/...) to work.
  # -----------------------
  install_vim() {
    echo "Installing vim 9..."
    if command -v apt &> /dev/null; then
      $SUDO apt update
      $SUDO apt install -y software-properties-common
      $SUDO add-apt-repository -y ppa:jonathonf/vim
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
    if [ "${VIM_MAJOR:-0}" -lt 9 ]; then
      echo "Vim ${VIM_MAJOR} is too old (need 8+), upgrading..."
      install_vim
    else
      echo "Vim ${VIM_MAJOR} OK — skipping."
    fi
  fi
else
  # -----------------------
  # Install Neovim
  # Pinned to 0.11.x: nvim-treesitter's master branch (used for our
  # parser highlighting) is locked for compatibility with Nvim 0.11.
  # -----------------------
  NVIM_VERSION="0.11.4"
  NVIM_MAJOR_MINOR=$(nvim --version 2>/dev/null | head -1 | grep -oP '\K[0-9]+\.[0-9]+')
  if [ "$NVIM_MAJOR_MINOR" != "0.11" ]; then
    echo "Installing neovim ${NVIM_VERSION}..."
    ARCH=$(uname -m)
    case "$ARCH" in
      x86_64)  NVIM_ARCH="linux-x86_64" ;;
      aarch64) NVIM_ARCH="linux-arm64" ;;
      *)       echo "⚠️ Unsupported architecture: $ARCH. Please install neovim manually." && exit 1 ;;
    esac
    curl -sLo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-${NVIM_ARCH}.tar.gz"
    $SUDO tar -xzf /tmp/nvim.tar.gz -C /usr/local --strip-components=1
    rm -f /tmp/nvim.tar.gz
    hash -r
    echo "neovim $(nvim --version | head -1) installed."
  else
    echo "neovim $(nvim --version | head -1) OK — skipping."
  fi

  # -----------------------
  # Install Node.js (required by mason for pyright, bashls, and
  # tree-sitter-cli). The apt-provided nodejs is too old (v12), so
  # use NodeSource for a current LTS.
  # -----------------------
  NODE_MAJOR=$(node --version 2>/dev/null | grep -oP '^v\K[0-9]+')
  if [ -z "$NODE_MAJOR" ] || [ "$NODE_MAJOR" -lt 18 ]; then
    echo "Installing Node.js (current LTS)..."
    if command -v apt &> /dev/null; then
      # Remove old apt-provided Node.js, which conflicts with NodeSource's package
      $SUDO apt remove -y nodejs libnode-dev libnode72 &> /dev/null || true
      curl -fsSL https://deb.nodesource.com/setup_lts.x | $SUDO bash -
      $SUDO apt install -y nodejs
    else
      echo "⚠️ apt not found. Please install Node.js manually."
    fi
  else
    echo "Node.js $(node --version) OK — skipping."
  fi

  # -----------------------
  # Install unzip (needed by mason to unpack some LSP server archives)
  # -----------------------
  if ! command -v unzip &> /dev/null; then
    echo "Installing unzip..."
    if command -v apt &> /dev/null; then
      $SUDO apt update
      $SUDO apt install -y unzip
    else
      echo "⚠️ apt not found. Please install unzip manually."
    fi
  else
    echo "unzip OK — skipping."
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

if [ "$EDITOR_CHOICE" = "vim" ]; then
  # -----------------------
  # Install fzf.vim
  # -----------------------
  mkdir -p ~/.vim/pack/vendor/start

  if [ ! -d "$HOME/.vim/pack/vendor/start/fzf.vim" ]; then
    git clone https://github.com/junegunn/fzf.vim.git \
      ~/.vim/pack/vendor/start/fzf.vim
  fi

  # -----------------------
  # Install sonokai colorscheme
  # -----------------------
  if [ ! -d "$HOME/.vim/pack/vendor/start/sonokai" ]; then
    git clone https://github.com/sainnhe/sonokai.git \
     ~/.vim/pack/vendor/start/sonokai
  fi
fi

# -----------------------
# Make sure undodir exists
# -----------------------
mkdir -p ~/.vim/undodir

# -----------------------
# Set default git editor
# -----------------------
if [ "$EDITOR_CHOICE" = "vim" ]; then
  git config --global core.editor "vim"
  git config --global diff.tool vimdiff
  git config --global merge.tool vimdiff
else
  git config --global core.editor "nvim"
  git config --global diff.tool nvimdiff
  git config --global merge.tool nvimdiff
fi
git config --global difftool.prompt false

echo "Done."
