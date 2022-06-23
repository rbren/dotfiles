#!/bin/bash
set -eo pipefail

cp dotfiles/.bashrc ~/
cp -r dotfiles/bashrc.d ~/
cp dotfiles/.vimrc ~/
cp dotfiles/.tmux.conf ~/
cp dotfiles/.gitignore ~/

mkdir -p ~/.config/nvim
cp dotfiles/init.vim ~/.config/nvim/
cp dotfiles/starship.toml ~/.config/

echo "installing tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

echo "setting up cron"
crontab -l > ./cron-tmp || true
cat ./dotfiles/cron >> ./dotfiles/cron-tmp
crontab ./dotfiles/cron-tmp
rm ./dotfiles/cron-tmp


