HISTSIZE=5000000
HISTFILESIZE=10000000
HISTTIMEFORMAT=" "
shopt -s histappend

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'
