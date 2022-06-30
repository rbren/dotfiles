alias randstr='head /dev/urandom | tr -dc A-Za-z0-9 | head -c '

alias golintall='go list ./... | grep -v vendor | xargs -L 1 golint -set_exit_status'

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias lsl='ls -lahG';
else
  alias lsl='ls -lah --color=auto';
fi
alias psa='ps aux';
alias diskdirs='du --max-depth=1 -c -h | sort -h'
alias vi='nvim';
alias src='source ~/.bashrc';
alias resrc='rm -r ~/bashrc.d && cp -r ~/git/homedir/dotfiles/bashrc.d ~/bashrc.d && cp ~/git/homedir/dotfiles/.bashrc ~/'

alias bowin='bower install --save';
alias npin='npm install --save';
alias npind='npm install --save-dev';

DEVSTATION_OPTIONS="--privileged"
DEVSTATION_PLATFORM="--platform linux/arm64"
DEVSTATION_PORTS="-p 3000-4000:3000-4000 -p 9000-9999:9000-9999"
DEVSTATION_RESOURCES="--memory=100g --cpus=4"
DEVSTATION_DOCKER_OPTS="-v /var/run/docker.sock:/var/run/docker.sock --add-host=host.docker.internal:host-gateway"
DEVSTATION_DIRS=""
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/git/:/home/rbren/git/"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/dockerstate/.bash_history.d:/home/rbren/.bash_history.d"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/dockerstate/.local-bashrc:/home/rbren/.local-bashrc"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/dockerstate/tmux-resurrect:/home/rbren/.tmux/resurrect"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/dockerstate/direnv-allow:/home/rbren/.local/share/direnv/allow/"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/.awsvault:/home/rbren/.awsvault"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/.ssh/:/home/rbren/.ssh/"
DEVSTATION_DIRS="$DEVSTATION_DIRS -v $HOME/.gnupg:/home/rbren/.gnupg"
DEVSTATION_FLAGS="$DEVSTATION_OPTIONS $DEVSTATION_PLATFORM $DEVSTATION_PORTS $DEVSTATION_RESOURCES $DEVSTATION_DIRS $DEVSTATION_DOCKER_OPTS"
alias devstation="docker run -it $DEVSTATION_FLAGS devstation"
