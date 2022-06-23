#!/bin/bash
set -eo pipefail

export PATH="$PATH:$HOME/.asdf/bin/"

echo "installing Python"
sudo apt-get install -y zlib1g-dev libssl-dev
asdf plugin-add python
asdf install python 3.6.12

echo "installing Go"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang 1.18.1

echo "installing NodeJS"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 18.4.0

