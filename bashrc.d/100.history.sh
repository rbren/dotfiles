HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT=" "
shopt -s histappend

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'
