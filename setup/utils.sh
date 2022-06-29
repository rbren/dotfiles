#!/bin/bash
set -eo pipefail

export PATH="$PATH:$HOME/.asdf/bin/"
asdf global nodejs 18.4.0 # TODO: make this automatic
export PATH="$PATH:`asdf where nodejs`/bin/"

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

echo "installing http-server"
npm i -g http-server

echo "installing ping"
sudo apt-get install iputils-ping
