#!/bin/bash
set -eo pipefail

export DEBIAN_FRONTEND=noninteractive
export ARCH_STRING="amd64"
export ARCH_STRING_SECONDARY="x86_64"

#./setup/installers.sh
#./setup/languages.sh
./setup/utils.sh
./setup/git.sh
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
