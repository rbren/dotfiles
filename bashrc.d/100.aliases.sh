alias gitc='git commit -a -m'
alias gita='git commit -a --amend --no-edit'
alias gitop='git push -u origin  $(parse_git_branch 2> /dev/null)'
alias gitfp='git push -u origin +$(parse_git_branch 2> /dev/null)'

alias k='kubectl';
alias kw='watch kubectl';
alias kns='kubectl config set-context --current --namespace '

alias d='sudo docker';
alias dockerstop='d stop $(d ps -a -q)';
alias dockerrm='d rm $(d ps -a -q)';
alias dockerrmi='d rmi $(d images -f "dangling=true" -q)';
alias dockerrmif="d rmi $(d images -q)";
alias dockercleanproc='d ps -aq --no-trunc | xargs sudo docker rm'
alias dockercleanimg='d images -q --filter dangling=true | xargs sudo docker rmi'
alias dockerpurgeimg='d images -q | xargs sudo docker rmi -f'
alias dockercleanvol='d volume ls -qf dangling=true | xargs -r sudo docker volume rm'
alias dockerclean='dockercleanproc ; dockercleanimg ; dockercleanvol'
alias dockerpristine='dockercleanproc ; dockerpurgeimg ; dockercleanvol'

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

alias bowin='bower install --save';
alias npin='npm install --save';
alias npind='npm install --save-dev';
