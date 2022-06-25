#!/bin/bash
set -eo pipefail

asdf global nodejs 18.4.0 # TODO: make this automatic
export PATH="$PATH:`asdf where nodejs`/bin/"

echo "installing basic utils from apt"
sudo apt-get update
sudo apt-get install -y sudo cron vim curl build-essential git tmux direnv unzip

echo "installing asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
export PATH="$PATH:$HOME/.asdf/bin/"

echo "installing Starship"
asdf plugin add starship
asdf install starship 1.8.0

echo "installing AWS CLI"
if [[ $ARCH_STRING -eq "amd64" ]]; then
  curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
else
  curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
fi
unzip awscliv2.zip
sudo ./aws/install

echo "installing NeoVim"
sudo apt-get install -y neovim

echo "installing Vim-Plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "installing jq and yq"
sudo apt-get install -y jq
curl -fL "https://github.com/mikefarah/yq/releases/download/v4.11.2/yq_linux_$ARCH_STRING" > yq
chmod +x yq
sudo mv ./yq /usr/local/bin/

npm i -g http-server
