```
# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install starship
brew install nvim
brew install asdf
brew install git

asdf plugin add nodejs
asdf install nodejs latest

mkdir ~/git && cd ~/git
git clone https://github.com/rbren/homedir
cd homedir
cp -r dotfiles/.* ~/
cp -r dotfiles/* ~/
echo ". ~/.bashrc" >> ~/.bash_profile

# Copy github keys
git remote set-url origin ssh://git@github.com/rbren/homedir
```
