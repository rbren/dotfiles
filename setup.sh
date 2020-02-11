set -e

cp .bashrc ~/
cp -r bashrc.d ~/
cp .vimrc ~/
cp .tmux.conf ~/
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/

crontab -l > ./cron-tmp || true
cat ./cron >> ./cron-tmp
crontab ./cron-tmp
rm ./cron-tmp

sudo apt-get update
sudo apt-get install -y vim curl build-essential git python3 python3-pip python2.7 python-pip php7.0 tmux direnv

echo "installing AWS CLI"
pip3 install awscli --upgrade --user

echo "installing Go"
wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
sudo tar -xvf go1.13.1.linux-amd64.tar.gz
sudo mv go /usr/local
rm go1.13.1.linux-amd64.tar.gz

echo "installing NeoVim"
curl -LO "https://github.com/neovim/neovim/releases/download/v0.4.2/nvim.appimage"
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim

echo "installing NodeJS"
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Install docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
echo "installing docker"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $USER

echo "installing kubectl"
# Install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install helm
echo "installing helm 3"
#curl -L "https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz" > helm.tar.gz
curl -L "https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz" > helm.tar.gz
tar -xvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
#sudo mv linux-amd64/tiller /usr/local/bin/
rm helm.tar.gz
rm -rf linux-amd64

git config --global user.name "Robert Brennan"
git config --global user.email bobby.brennan@gmail.com

echo "installing vim bundles"
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

cd
echo -e "\n\n\n"
echo "to finish setup:"
echo " * copy your AWS creds over"
echo " * copy your github SSH key over"
echo " * run:"
echo "    newgrp docker"
echo "    source ~/.bashrc"
echo -e "\n\n\n"
