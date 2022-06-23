#!/bin/bash
set -eo pipefail

export PATH="$PATH:$HOME/.asdf/bin/"

echo "installing Python"
# TODO: use asdf. https://github.com/danhper/asdf-python/issues/117
sudo apt-get install -y python3.10 python3-pip

echo "installing Go"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang 1.18.1

echo "installing NodeJS"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 18.4.0

