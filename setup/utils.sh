#!/bin/bash
set -eo pipefail

# TODO: dedupe this, also in fairwinds.sh, and npm-global is defined a few places
export PATH="$PATH:$HOME/.asdf/bin/"
asdf global `cat ./dotfiles/.tool-versions  | grep nodejs`
export PATH="$PATH:`asdf where nodejs`/bin/"
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
asdf_install() {
  asdf plugin-add $1 $2
  asdf install $1 `cat ./dotfiles/.tool-versions  | grep $1 | cut -d" " -f2`
}

echo "installing Starship"
asdf_install starship

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

echo "installing ssh"
sudo apt-get install -y ssh

echo "installing ping"
sudo apt-get install -y iputils-ping

echo "installing gpg"
sudo apt-get install -y gnupg2

echo "installing postgres"
sudo apt-get install -y libpq-dev

echo "installing sshuttle"
sudo apt-get install -y sshuttle

echo "installing postgres-client"
sudo apt-get install -y postgresql-client

echo "installing pup"
go install github.com/ericchiang/pup@latest

