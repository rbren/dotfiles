pathadd() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

pathadd "${KREW_ROOT:-$HOME/.krew}/bin"
pathadd "$HOME/Library/Haskell/bin"
pathadd "$HOME/.cabal/bin"
pathadd "$HOME/.rvm/bin"
pathadd "$HOME/.local/bin"
pathadd "$HOME/anaconda3/bin"
pathadd "$HOME/anaconda2/bin"
pathadd "$HOME/.npm-global/bin"
pathadd "`npm config get prefix`/bin"
pathadd "$HOME/.npm-packages/bin"
pathadd "$HOME/.linuxbrew/bin/:/home/linuxbrew/.linuxbrew/bin/"
pathadd "$GOPATH/bin"
pathadd "$GOROOT/bin"
pathadd "$HOME/gems/bin"
pathadd "$HOME/.cargo/bin"
pathadd "$HOME/bin"
