alias k='kubectl';
alias kw='watch kubectl';
alias kns='kubectl config set-context --current --namespace '

function klogs() {
  kubectl logs -f $(kubectl get pods | awk "/$1/ {print \$1;exit}")
}
