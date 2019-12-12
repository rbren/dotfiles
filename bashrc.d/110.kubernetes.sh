alias k='kubectl';
alias kw='watch kubectl';
alias kns='kubectl config set-context --current --namespace '
alias kport='kubectl port-forward --address 0.0.0.0'
alias klog='stern --output raw'
alias kkind='export KUBECONFIG=/home/ubuntu/.kube/kind-config-kind'

function klogs() {
  kubectl logs -f $(kubectl get pods | awk "/$1/ {print \$1;exit}")
}

function parse_k8s_status() {
  ctx=`kubectl config current-context 2> /dev/null`
  if [ $? -eq 0 ] ; then
    echo "$ctx `kubectl config view --minify --output 'jsonpath={..namespace}'`"
  fi
}
