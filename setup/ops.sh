#!/bin/bash
set -eo pipefail

# Install docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
echo "installing docker"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$ARCH_STRING] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable"
sudo apt update
sudo apt install -y docker.io

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

