#!/bin/bash
set -eo pipefail

echo "installing Fairwinds tooling"
export PATH="$PATH:$HOME/.asdf/bin/"

# TODO: dedupe this with other files
asdf global `cat ./dotfiles/.tool-versions  | grep nodejs`
export PATH="$PATH:`asdf where nodejs`/bin/"
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH="$PATH:~/.npm-global/bin"

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
asdf plugin-add sops https://github.com/feniix/asdf-sops.git
asdf install sops 3.7.3

# Cuddlefish
export CUDDLEFISH_NO_INTERACTIVE=1
git clone git@github.com:FairwindsOps/cuddlefish.git ~/git/cuddlefish
cd ~/git/cuddlefish
./bin/configure.sh
cd

. ~/.cuddlefish/config

cthulhucuddle asdf export > .tool-versions-raw
tr '[:upper:]' '[:lower:]' < .tool-versions-raw > .tool-versions
sed -i 's/export asdf_//' .tool-versions
sed -i 's/_version//' .tool-versions
sed -i 's/=/ /' .tool-versions
sed -i 's/_/-/' .tool-versions
cat .tool-versions | cut -d' ' -f1 | grep "^[^\#]" | xargs -i asdf plugin add  {} || true
asdf install
rm .tool-versions
rm .tool-versions-raw

