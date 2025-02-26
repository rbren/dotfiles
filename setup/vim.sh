#!/bin/bash
set -eo pipefail

echo "installing NeoVim"
sudo apt-get install -y ninja-build gettext libtool-bin cmake g++ pkg-config unzip curl
git clone https://github.com/neovim/neovim
cd neovim
git checkout v0.9.5
make CMAKE_BUILD_TYPE=Release
sudo make install
cd ..
rm -rf neovim

echo "installing AstroVim"
git clone --branch v3.40.3 --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

echo "installing Vim-Plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


echo "installing vim bundles"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
dir=$PWD

git clone https://github.com/github/copilot.vim ~/.config/nvim/pack/github/start/copilot.vim
git clone https://github.com/digitaltoad/vim-pug.git
git clone https://github.com/Quramy/vim-js-pretty-template
git clone https://github.com/plasticboy/vim-markdown.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone https://github.com/hashivim/vim-terraform.git ~/.vim/bundle/vim-terraform
cd $dir
