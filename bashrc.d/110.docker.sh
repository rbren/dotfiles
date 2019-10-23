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


