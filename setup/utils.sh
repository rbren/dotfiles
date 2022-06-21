#!/bin/bash
set -eo pipefail

echo "installing basic utils from apt"
sudo apt-get update
sudo apt-get install -y sudo cron vim curl build-essential git tmux direnv unzip

echo "installing asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
export PATH="$PATH:$HOME/.asdf/bin/"

echo "installing Starship"
asdf plugin add starship
asdf install starship latest
asdf global starship latest

echo "installing AWS CLI"
pip3 install awscli --upgrade --user

echo "installing NeoVim"
curl -L "https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.tar.gz" > nvim.tar.gz
tar -xzvf nvim.tar.gz
sudo mv ./nvim-linux64/bin/nvim /usr/bin/nvim

echo "installing Vim-Plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "installing jq and yq"
sudo apt-get install -y jq
curl -L "https://github.com/mikefarah/yq/releases/download/v4.11.2/yq_linux_amd64" > yq
chmod +x yq
sudo mv ./yq /usr/local/bin/

echo "installing tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
