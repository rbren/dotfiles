# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi


set -o vi
export EDITOR=vi

git config --global credential.helper 'cache --timeout=3000'

HISTSIZE=5000
HISTFILESIZE=10000

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function parse_git_status () {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  remote_pattern="branch is (.*) by"
  diverge_pattern="branch and (.*) have diverged"
  status_pattern="working (.*) clean"
  branch="$(parse_git_branch 2> /dev/null)"
  color=$GREEN
  direction=""
  if [[ ! ${git_status} =~ ${status_pattern} ]]; then
    color="${RED}"
  fi
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} =~ "ahead" ]]; then
      direction="${YELLOW}↑"
    else
      direction="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    direction="${YELLOW}↕"
  fi
  echo "$color$branch$direction"
}
function set_prompt() {
  status=$(parse_git_status)
  PS1="$PROMPT_PREFIX \w${status}$NO_COLOR\$ "
}
PROMPT_COMMAND=set_prompt
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

alias src='source ~/.bashrc';
alias d='docker';
alias dockerstop='sudo docker stop $(sudo docker ps -a -q)';
alias dockerrm='sudo docker rm $(sudo docker ps -a -q)';
alias dockerrmi='sudo docker rmi $(sudo docker images -f "dangling=true" -q)';
alias dockercleanproc='sudo docker ps -aq --no-trunc | xargs sudo docker rm'
alias dockercleanimg='sudo docker images -q --filter dangling=true | xargs sudo docker rmi'
alias dockercleanvol='sudo docker volume ls -qf dangling=true | xargs -r sudo docker volume rm'
alias dockerclean='dockercleanproc ; dockercleanimg ; dockercleanvol'

alias lsl='ls -lah';
alias psa='ps aux';
alias seek='grep --color -re';

alias diskdirs='du --max-depth=1 -c -h'

alias bowin='bower install --save';
alias npin='npm install --save';
alias npind='npm install --save-dev';

export PATH="$PATH:$HOME/Library/Haskell/bin";
export PATH="$PATH:$HOME/.cabal/bin";
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/anaconda3/bin"
export PATH="$PATH:$HOME/anaconda2/bin"
export PATH="$PATH:`npm config get prefix`/bin"

# For nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

flip() {
  FLIP_SET='set'
  if [ $# -eq 0 ]
    then
      TODIR=0
    else
      TODIR=$1
  fi
  if [[ "$1" == "$FLIP_SET" ]]; then
    FLIP[$2]=$3
  else
    CWD=`pwd`
    cd ${FLIP[$TODIR]}
    flip set 0 $CWD
  fi
}

ghc() {
  git clone "https://github.com/$1"
}

gitcheck() {
  for dir in ~/git/*; do
    gitstat=`cd $dir && parse_git_status`
    gitstat=$NO_COLOR$gitstat$NO_COLOR
    gitstat=${gitstat//\\[/}
    gitstat=${gitstat//\\]/}
    (cd "$dir" && echo -e "$gitstat: $dir")
  done
}

if [ -f ~/.local-bashrc ]; then
  source ~/.local-bashrc
fi

