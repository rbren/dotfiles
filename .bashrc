# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

set -o vi

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
