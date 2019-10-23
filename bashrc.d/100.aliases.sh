alias randstr='head /dev/urandom | tr -dc A-Za-z0-9 | head -c '

alias golintall='go list ./... | grep -v vendor | xargs -L 1 golint -set_exit_status'

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias lsl='ls -lahG';
else
  alias lsl='ls -lah --color=auto';
fi
alias psa='ps aux';
alias seek='grep --color -re';
alias diskdirs='du --max-depth=1 -c -h | sort -h'
alias vi='nvim';
alias src='source ~/.bashrc';
alias resrc='rm -r ~/bashrc.d && cp -r ~/git/homedir/bashrc.d ~/ && cp ~/git/homedir/.bashrc ~/ && source ~/.bashrc'

alias bowin='bower install --save';
alias npin='npm install --save';
alias npind='npm install --save-dev';
