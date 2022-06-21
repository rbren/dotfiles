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


