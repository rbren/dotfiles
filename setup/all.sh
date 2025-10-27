#!/bin/bash
set -eo pipefail

export DEBIAN_FRONTEND=noninteractive
export ARCH_STRING="amd64"
export ARCH_STRING_SECONDARY="x86_64"

# Disable interactive prompts during install
sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

echo -e "\n\n\n===================INSTALLERS=================\n\n\n"
./setup/installers.sh

echo -e "\n\n\n===================LANGUAGES=================\n\n\n"
./setup/languages.sh
echo -e "\n\n\n===================UTILS=================\n\n\n"
./setup/utils.sh
echo -e "\n\n\n===================GIT=================\n\n\n"
./setup/git.sh
echo -e "\n\n\n===================VIM=================\n\n\n"
./setup/vim.sh
echo -e "\n\n\n===================OPS=================\n\n\n"
./setup/ops.sh
echo -e "\n\n\n===================DOTFILES=================\n\n\n"
./setup/dotfiles.sh

echo -e "\n\n\n"
echo "to finish setup:"
echo " * copy your AWS creds over"
echo " * copy your github SSH key over"
echo " * run:"
echo "    sudo usermod -aG docker $USER"
echo "    newgrp docker"
echo "    source ~/.bashrc"
echo -e "\n\n\n"
