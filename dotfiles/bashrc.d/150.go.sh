export GOROOT="$(asdf where golang)/go"
export GOPATH=$HOME/go
pathadd "$GOROOT/bin"
pathadd "$GOPATH/bin"

