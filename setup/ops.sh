#!/bin/bash
set -eo pipefail
sudo apt-get update

# Install docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
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

echo "installing kubectl"
curl -fLs https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

echo "installing helm"
curl -fL "https://get.helm.sh/helm-v3.0.2-linux-$ARCH_STRING.tar.gz" > helm.tar.gz
tar -xvf helm.tar.gz
sudo mv linux-$ARCH_STRING/helm /usr/local/bin/
rm helm.tar.gz
rm -rf linux-$ARCH_STRING

echo "installing KIND"
curl -fLo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-$(uname)-$ARCH_STRING
chmod +x ./kind
sudo mv ./kind /usr/local/bin/

