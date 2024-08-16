#!/bin/bash
set -eo pipefail

sudo apt-get update
export PATH="$PATH:$HOME/.asdf/bin/"
asdf_install() {
  asdf plugin-add $1 $2
  asdf install $1 `cat ./dotfiles/.tool-versions  | grep "^$1\s" | cut -d" " -f2`
}

echo "installing docker"
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "installing terraform"
asdf_install terraform https://github.com/Banno/asdf-hashicorp.git

echo "installing kubectl"
asdf_install kubectl https://github.com/asdf-community/asdf-kubectl.git

echo "installing helm"
asdf_install helm https://github.com/Antiarchitect/asdf-helm.git

echo "installing KIND"
asdf_install kind https://github.com/johnlayton/asdf-kind

echo "installing Stern"
asdf_install stern https://github.com/looztra/asdf-stern

echo "installing helm-docs"
asdf_install helm-docs https://github.com/sudermanjr/asdf-helm-docs.git

echo "installing Trivy"
asdf_install trivy https://github.com/zufardhiyaulhaq/asdf-trivy.git

echo "installing gcloud"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install -y google-cloud-cli

echo "installing reckoner"
curl -fL "https://github.com/FairwindsOps/reckoner/releases/download/v6.0.0/reckoner_6.0.0_linux_$ARCH_STRING.tar.gz" > reckoner.tar.gz
tar -xvf reckoner.tar.gz
sudo mv reckoner /usr/local/bin/

echo "installing aws-vault"
asdf_install aws-vault https://github.com/virtualstaticvoid/asdf-aws-vault.git

echo "installing hashi vault"
asdf_install vault

echo "installing SOPS"
asdf_install sops https://github.com/feniix/asdf-sops.git


