alias k='kubectl';
alias kw='watch kubectl';
alias kns='kubectl config set-context --current --namespace '

function klogs() {
  kubectl logs -f $(kubectl get pods | awk "/$1/ {print \$1;exit}")
}

function parse_k8s_status() {
  ctx=`k config current-context &> /dev/null`
  if [ $? -eq 0 ] ; then
    echo "$ctx `kubectl config view --minify --output 'jsonpath={..namespace}'`"
  fi
}
