#!/bin/bash
set -eo pipefail

export PATH="$PATH:$HOME/.asdf/bin/"
sudo apt-get update

echo "installing python"
sudo apt-get install -y python3.10 python3-pip

echo "installing PHP"
sudo apt-get install -y php7.0

echo "installing Go"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang 1.18.1
asdf global golang 1.18.1

echo "installing NodeJS"
curl -fsL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo apt-get install -y nodejs
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

