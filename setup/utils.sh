#!/bin/bash
set -eo pipefail

# TODO: dedupe this, also in fairwinds.sh, and npm-global is defined a few places
export PATH="$PATH:$HOME/.asdf/bin/"
asdf global `cat ./dotfiles/.tool-versions  | grep nodejs`
asdf global `cat ./dotfiles/.tool-versions  | grep golang`
export PATH="$PATH:`asdf where nodejs`/bin/"
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
asdf_install() {
  asdf plugin-add $1 $2
  asdf install $1 `cat ./dotfiles/.tool-versions  | grep "^$1\s" | cut -d" " -f2`
}
export PATH="$PATH:$(asdf where golang)/go/bin/"

echo "installing Starship"
asdf_install starship

echo "installing yq"
asdf_install yq

echo "installing AWS CLI"
curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH_STRING_SECONDARY.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

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

echo "installing git-lfs"
sudo apt-get install -y git-lfs
