#!/bin/bash
set -eo pipefail

echo "installing Fairwinds tooling"
. dotfiles/bashrc.d/001.path.sh
export PATH="$PATH:$HOME/.asdf/bin/"

# terraform
curl -fL "https://releases.hashicorp.com/terraform/1.2.3/terraform_1.2.3_linux_$ARCH_STRING.zip" > terraform.zip
unzip terraform.zip
sudo mv ./terraform /usr/local/bin/

#venv
sudo apt-get update
sudo apt-get install -y python3-venv

# runner
npm install -g bash-task-runner

# reckoner
curl -fL "https://github.com/FairwindsOps/reckoner/releases/download/v6.0.0/reckoner_6.0.0_linux_$ARCH_STRING.tar.gz" > reckoner.tar.gz
tar -xvf reckoner.tar.gz
sudo mv reckoner /usr/local/bin/

# aws-vault
curl -fL "https://github.com/99designs/aws-vault/releases/download/v5.4.4/aws-vault-linux-$ARCH_STRING" > aws-vault
chmod +x aws-vault
sudo mv aws-vault /usr/local/bin/

# HashiCorp Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$ARCH_STRING] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault

# SOPS
curl -fL "https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux" > sops
chmod +x sops
sudo mv sops /usr/local/bin/

# Cuddlefish
export CUDDLEFISH_NO_INTERACTIVE=1
git clone git@github.com:FairwindsOps/cuddlefish.git ~/git/cuddlefish
cd ~/git/cuddlefish
./bin/configure.sh
cd

eval $(cthulhucuddle asdf export)
asdf install
