#!/bin/bash
set -eo pipefail

echo "installing vim bundles"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
dir=$PWD
git clone https://github.com/digitaltoad/vim-pug.git
git clone https://github.com/Quramy/vim-js-pretty-template
git clone https://github.com/plasticboy/vim-markdown.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone https://github.com/zivyangll/git-blame.vim ~/.vim/bundle/git-blame.vim
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/hashivim/vim-terraform.git ~/.vim/bundle/vim-terraform
cd $dir
