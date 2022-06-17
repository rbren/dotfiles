set -e

cp dotfiles/.bashrc ~/
cp -r dotfiles/bashrc.d ~/
cp dotfiles/.vimrc ~/
cp dotfiles/.tmux.conf ~/
mkdir -p ~/.config/nvim
cp dotfiles/init.vim ~/.config/nvim/
cp dotfiles/starship.toml ~/.config/

sudo apt-get update
sudo apt-get install -y sudo cron vim curl build-essential git python3.10 python3-pip php7.0 tmux direnv unzip

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
export PATH="$PATH:$HOME/.asdf/bin/"

pwd
ls -lah /setup
crontab -l > ./cron-tmp || true
cat ./dotfiles/cron >> ./dotfiles/cron-tmp
crontab ./dotfiles/cron-tmp
rm ./dotfiles/cron-tmp

echo "installing Starship"
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

echo "installing AWS CLI"
pip3 install awscli --upgrade --user

echo "installing Go"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang 1.18.1
asdf global golang 1.18.1

echo "installing NeoVim"
curl -L "https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.tar.gz" > nvim.tar.gz
tar -xzvf nvim.tar.gz
sudo mv ./nvim-linux64/bin/nvim /usr/bin/nvim

echo "installing Vim-Plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "installing NodeJS"
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo apt-get install -y nodejs
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Install docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
echo "installing docker"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable"
sudo apt update
sudo apt install -y docker.io

echo "installing kubectl"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

echo "installing helm"
curl -L "https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz" > helm.tar.gz
tar -xvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
rm helm.tar.gz
rm -rf linux-amd64

curl -L "https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz" > helm.tar.gz
tar -xvf helm.tar.gz
sudo mv linux-amd64/tiller /usr/local/bin/
sudo mv linux-amd64/helm /usr/local/bin/helm2
rm helm.tar.gz
rm -rf linux-amd64

echo "installing KIND"
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-$(uname)-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/

echo "installing jq and yq"
sudo apt-get install -y jq
curl -L "https://github.com/mikefarah/yq/releases/download/v4.11.2/yq_linux_amd64" > yq
chmod +x yq
sudo mv ./yq /usr/local/bin/

git config --global user.name "Robert Brennan"
git config --global user.email contact@rbren.io

echo "installing vim bundles"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
dir=$PWD
git clone https://github.com/digitaltoad/vim-pug.git
git clone https://github.com/Quramy/vim-js-pretty-template
git clone https://github.com/plasticboy/vim-markdown.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
git clone https://github.com/zivyangll/git-blame.vim ~/.vim/bundle/git-blame.vim
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/hashivim/vim-terraform.git ~/.vim/bundle/vim-terraform
cd $dir

echo "installing Fairwinds tooling"

# terraform
curl -L "https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip" > tf.zip
unzip tf.zip
sudo mv terraform /usr/local/bin/
rm tf.zip

#venv
sudo pip3 install virtualenv

# runner
npm install -g bash-task-runner

# reckoner
curl -L "https://github.com/FairwindsOps/reckoner/releases/download/v3.2.1/reckoner-linux-amd64" > reckoner
chmod +x reckoner
sudo mv reckoner /usr/local/bin/

# aws-vault
curl -L "https://github.com/99designs/aws-vault/releases/download/v5.4.4/aws-vault-linux-amd64" > aws-vault
chmod +x aws-vault
sudo mv aws-vault /usr/local/bin/

# SOPS
curl -L "https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux" > sops
chmod +x sops
sudo mv sops /usr/local/bin/

cd
echo -e "\n\n\n"
echo "to finish setup:"
echo " * copy your AWS creds over"
echo " * copy your github SSH key over"
echo " * run:"
echo "    sudo usermod -aG docker $USER"
echo "    newgrp docker"
echo "    source ~/.bashrc"
echo -e "\n\n\n"
