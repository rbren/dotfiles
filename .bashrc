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

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function parse_git_status () {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  remote_pattern="branch is (.*) by"
  diverge_pattern="branch and (.*) have diverged"
  branch="$(parse_git_branch 2> /dev/null)"
  color=$GREEN
  direction=""
  if [[ ! ${git_status} =~ "working directory clean" ]]; then
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
  PS1="$GREEN$NO_COLOR:\w${status}$NO_COLOR\$ "
}
PROMPT_COMMAND=set_prompt
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

alias src='source ~/.bashrc';
alias d='docker';
alias dstop='docker stop $(docker ps -a -q)';
alias drm='docker rm $(docker ps -a -q)';
alias drmi='docker rmi $(docker images -f "dangling=true" -q)';

alias lsl='ls -la';
alias psa='ps aux';

alias diskdirs='du --max-depth=1 -c -h'

alias bowin='bower install --save';
alias npin='npm install --save';
alias npind='npm install --save-dev';

export PATH="$PATH:$HOME/npm/bin";
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

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

