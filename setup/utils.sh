#!/bin/bash
set -eo pipefail

echo "apt-get update"
sudo apt-get update

echo "installing bash-completion"
sudo apt-get install -y bash-completion

# TODO: dedupe this, npm-global is defined a few places
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

#echo "installing AWS CLI"
#curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH_STRING_SECONDARY.zip" -o "awscliv2.zip"
#unzip awscliv2.zip
#sudo ./aws/install

echo "installing jq"
sudo apt-get install -y jq

echo "installing http-server"
npm i -g http-server

echo "installing lsof"
sudo apt-get install -y lsof

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

echo "installing postgresql-client"
sudo apt-get install -y postgresql-client

echo "installing mysql-client"
sudo apt-get install -y mysql-client

echo "installing git-lfs"
sudo apt-get install -y git-lfs

echo "installing tools for VCV rack"
sudo apt-get install -y unzip git gdb curl cmake libx11-dev libglu1-mesa-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev zlib1g-dev libasound2-dev libgtk2.0-dev libgtk-3-dev libjack-jackd2-dev jq zstd libpulse-dev pkg-config

