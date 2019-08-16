set -e

cp .bashrc ~/
cp .vimrc ~/
cp .tmux.conf ~/

crontab -l > ./cron-tmp || true
cat ./cron >> ./cron-tmp
crontab ./cron-tmp
rm ./cron-tmp

sudo apt-get update
sudo apt-get install -y curl build-essential git python3 python3-pip python2.7 python-pip php7.0 golang-go tmux

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Install docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $USER
newgrp docker

# Install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install helm
sudo snap install helm --classic

git config --global user.name "Bobby Brennan"
git config --global user.email bobby.brennan@gmail.com

mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
git clone git://github.com/digitaltoad/vim-pug.git
git clone https://github.com/Quramy/vim-js-pretty-template
git clone https://github.com/plasticboy/vim-markdown.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
git clone https://github.com/zivyangll/git-blame.vim ~/.vim/bundle/git-blame.vim

source ~/.bashrc
