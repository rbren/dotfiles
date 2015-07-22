# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

set -o vi

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function parse_git_color() {
  echo "${GREEN}"
}
function parse_git_status () {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  remote_pattern="branch is (.*) of"
  diverge_pattern="branch and (.*) have diverged"
  branch="$(parse_git_branch 2> /dev/null)"
  color=$GREEN
  direction=""
  if [[ ! ${git_status} =~ "working directory clean" ]]; then
    color="${RED}"
  else
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
      color="${YELLOW}"
      if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
        direction="↑"
      else
        direction="↓"
      fi
    fi
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
      color="${YELLOW}"
      direction="↕"
    fi
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

alias ls='ls -la';
alias grep='grep -r';
alias ps='ps aux';

alias bowin='bower --save';
alias npin='npm --save';
alias npind='npm --save-dev';

export PATH="$PATH:$HOME/npm/bin";


flip() {
  FLIP_SET='set'
  if [ $# -eq 0 ]
    then
      TODIR=0
    else
      TODIR=$1
  fi
  if [[ "$1" == "$FLIP_SET" ]]; then
    echo "set" . $3
    FLIP[$2]=$3
  else
    CWD=`pwd`
    echo "set cwd" $CWD
    cd ${FLIP[$TODIR]}
    flip set 0 $CWD
  fi
}
