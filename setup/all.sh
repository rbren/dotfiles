#!/bin/bash
set -eo pipefail

export ARCH_STRING="amd64"

./setup/utils.sh
./setup/git.sh
./setup/languages.sh
./setup/vim.sh
./setup/ops.sh
./setup/fairwinds.sh
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
