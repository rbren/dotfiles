# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

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

set -o vi
