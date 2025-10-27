# New mac setup

* Install:
  * Chrome
  * Slack
* Settings:
  * Enable FileVault
  * Make dock autohide
  * Stop spaces from rearranging automatically
  * Change modifier keys
    * caps -> esc
    * globe -> ctrl
    * ctrl -> globe
    
```
mkdir -p ~/Screenshots && defaults write com.apple.screencapture location ~/Screenshots
```

## Terminal setup


```
# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install starship
brew install nvim
brew install asdf
brew install git

cp -r astronvim/ ~/.config/nvim/lua/user

asdf plugin add nodejs
asdf install nodejs latest

mkdir ~/git && cd ~/git
git clone https://github.com/rbren/homedir
cd homedir
cp -r dotfiles/.* ~/
cp -r dotfiles/* ~/
echo ". ~/.bashrc" >> ~/.bash_profile

source ~/.bashrc

# Copy github keys, add GITHUB_ACCESS_TOKEN to ~/.bash_profile
git remote set-url origin ssh://git@github.com/rbren/homedir

./scripts/vim.sh

build_devbox
```
