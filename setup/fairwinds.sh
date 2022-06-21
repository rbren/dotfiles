#!/bin/bash
set -eo pipefail

echo "installing Fairwinds tooling"
. dotfiles/bashrc.d/001.path.sh

# terraform
curl -L "https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip" > tf.zip
unzip tf.zip
sudo mv terraform /usr/local/bin/
rm tf.zip

#venv
sudo apt install -y python3.10-venv

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

# HashiCorp Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault

# SOPS
curl -L "https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux" > sops
chmod +x sops
sudo mv sops /usr/local/bin/

# Cuddlefish
export CUDDLEFISH_NO_INTERACTIVE=1
git clone git@github.com:FairwindsOps/cuddlefish.git ~/git/cuddlefish
cd ~/git/cuddlefish
./bin/configure.sh
cd


