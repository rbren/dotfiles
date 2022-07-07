#!/bin/bash
set -eo pipefail

export PATH="$PATH:$HOME/.asdf/bin/"
asdf_install() {
  asdf plugin-add $1 $2
  asdf install $1 `cat ./dotfiles/.tool-versions  | grep $1 | cut -d" " -f2`
}

echo "installing Go"
asdf_install golang https://github.com/kennyp/asdf-golang.git

echo "installing NodeJS"
asdf_install nodejs https://github.com/asdf-vm/asdf-nodejs.git

echo "installing Python"
# TODO: asdf doesn't do headers, so we hack this in. https://github.com/danhper/asdf-python/issues/117
sudo apt-get install -y python3.10 python3-pip
asdf_install python

echo "installing Anaconda"
curl -L "https://github.com/conda-forge/miniforge/releases/download/4.12.0-3/Miniforge3-4.12.0-3-Linux-aarch64.sh" > miniforge.sh
bash ./miniforge.sh -b -u -p $HOME/miniforge
$HOME/miniforge/bin/conda init bash
