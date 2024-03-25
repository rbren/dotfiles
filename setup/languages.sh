#!/bin/bash
set -eo pipefail

export PATH="$PATH:$HOME/.asdf/bin/"
asdf_install() {
  asdf plugin-add $1 $2
  asdf install $1 `cat ./dotfiles/.tool-versions  | grep "^$1\s" | cut -d" " -f2`
}

echo "installing Python"
sudo apt update
sudo apt install -y \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev
asdf_install python https://github.com/danhper/asdf-python.git

echo "installing Go"
asdf_install golang https://github.com/kennyp/asdf-golang.git

echo "installing NodeJS"
asdf_install nodejs https://github.com/asdf-vm/asdf-nodejs.git

echo "installing Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y
