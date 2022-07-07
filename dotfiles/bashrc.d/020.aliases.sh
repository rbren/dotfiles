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

DEVBOX_OPTIONS="--privileged --network host"
DEVBOX_PLATFORM="--platform linux/arm64"
DEVBOX_PORTS="" #-p 3000-4000:3000-4000 -p 9000-9999:9000-9999"
DEVBOX_RESOURCES="--memory=100g --cpus=4"
DEVBOX_DOCKER_OPTS="-v /var/run/docker.sock:/var/run/docker.sock --add-host=host.docker.internal:host-gateway"
DEVBOX_DIRS=""
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/git/:/home/rbren/git/"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/dockerstate/.bash_history.d:/home/rbren/.bash_history.d"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/dockerstate/.local-bashrc:/home/rbren/.local-bashrc"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/dockerstate/tmux-resurrect:/home/rbren/.tmux/resurrect"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/dockerstate/direnv-allow:/home/rbren/.local/share/direnv/allow/"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/dockerstate/.vault-token:/home/rbren/.vault-token"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/.awsvault:/home/rbren/.awsvault"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/.ssh/:/home/rbren/.ssh/"
DEVBOX_DIRS="$DEVBOX_DIRS -v $HOME/.gnupg:/home/rbren/.gnupg"
DEVBOX_FLAGS="$DEVBOX_OPTIONS $DEVBOX_PLATFORM $DEVBOX_PORTS $DEVBOX_RESOURCES $DEVBOX_DIRS $DEVBOX_DOCKER_OPTS"
alias devbox="docker run --rm -it $DEVBOX_FLAGS devbox"

DEVBOX_BUILD_ARGS='--build-arg GITHUB_ACCESS_TOKEN=$GITHUB_ACCESS_TOKEN --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/github)"  --build-arg USER_NAME=$USER   --build-arg USER_ID=$UID'
alias build_devbox="docker build $DEVBOX_PLATFORM $DEVBOX_BUILD_ARGS -t devbox ~/git/homedir"
