#!/bin/bash
set -eo pipefail

echo "installing Fairwinds tooling"
export PATH="$PATH:$HOME/.asdf/bin/"
asdf_install() {
  asdf plugin-add $1 $2
  asdf install $1 `cat ./dotfiles/.tool-versions  | grep "^$1\s" | cut -d" " -f2`
}

# TODO: dedupe this with other files
asdf global `cat ./dotfiles/.tool-versions  | grep nodejs`
export PATH="$PATH:`asdf where nodejs`/bin/"
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH="$PATH:~/.npm-global/bin"

# terraform
echo "installing terraform"
asdf_install terraform https://github.com/Banno/asdf-hashicorp.git

# for cypress
sudo apt-get install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev xvfb libasound2


#venv
echo "installing venv"
sudo apt-get update
sudo apt-get install -y python3-venv

# runner
echo "installing bash-task-runner"
npm install -g bash-task-runner

# reckoner
echo "installing reckoner"
curl -fL "https://github.com/FairwindsOps/reckoner/releases/download/v6.0.0/reckoner_6.0.0_linux_$ARCH_STRING.tar.gz" > reckoner.tar.gz
tar -xvf reckoner.tar.gz
sudo mv reckoner /usr/local/bin/


# aws-vault
echo "installing aws-vault"
asdf_install aws-vault https://github.com/virtualstaticvoid/asdf-aws-vault.git

echo "installing hashi vault"
asdf_install vault

echo "installing SOPS"
asdf_install sops https://github.com/feniix/asdf-sops.git

echo "cloning cuddlefish"
export CUDDLEFISH_NO_INTERACTIVE=1
git clone git@github.com:FairwindsOps/cuddlefish.git ~/git/cuddlefish
cd ~/git/cuddlefish
./bin/configure.sh
cd

echo "configuring cuddlefish"
. ~/.cuddlefish/config

echo "Building custom cthulhucuddle"
git clone git@github.com:fairwindsops/cthulhucuddle ~/git/cthulhucuddle/
cd ~/git/cthulhucuddle/
git checkout rb/install-err
/home/rbren/.asdf/shims/go build main.go
mv main ~/.cuddlefish/bin/cthulhucuddle
cd

cthulhucuddle asdf export > .tool-versions-raw
tr '[:upper:]' '[:lower:]' < .tool-versions-raw > .tool-versions
sed -i 's/export asdf_//' .tool-versions
sed -i 's/_version//' .tool-versions
sed -i 's/=/ /' .tool-versions
sed -i 's/_/-/' .tool-versions
cat .tool-versions | cut -d' ' -f1 | grep "^[^\#]" | xargs -i asdf plugin add  {} || true
echo "installing via asdf"
cat .tool-versions
#asdf install || true # TODO: why does this fail?
rm .tool-versions
rm .tool-versions-raw

