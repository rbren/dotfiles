#!/bin/bash
set -eo pipefail

./setup/dotfiles.sh
./setup/utils.sh
./setup/git.sh
./setup/cron.sh
./setup/languages.sh
./setup/vim.sh
./setup/ops.sh
./setup/fairwinds.sh

echo -e "\n\n\n"
echo "to finish setup:"
echo " * copy your AWS creds over"
echo " * copy your github SSH key over"
echo " * run:"
echo "    sudo usermod -aG docker $USER"
echo "    newgrp docker"
echo "    source ~/.bashrc"
echo -e "\n\n\n"
