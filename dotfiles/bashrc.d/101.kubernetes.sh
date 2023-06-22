source <(kubectl completion bash)
source /etc/bash_completion
alias k='kubectl';
complete -o default -F __start_kubectl k

alias kw='watch kubectl';
alias kns='kubectl config set-context --current --namespace '
alias kport='kubectl port-forward --address 0.0.0.0'
alias klog='stern --output raw'
alias kindpause='docker ps | grep kindest | cut -d" " -f 1 | xargs docker pause'
alias kindunpause='docker ps | grep kindest | cut -d" " -f 1 | xargs docker unpause'

function kkind() {
  cluster=${1:-kind}
  if [[ $cluster == "docker" ]]; then
    cluster="kind"
  fi
  mkdir -p $HOME/.kube
  kind get kubeconfig --name=${cluster} > $HOME/.kube/kind-config-kind
  if [[ $1 == "docker" ]] || [[ $2 == "docker" ]]; then
    sed -i 's/127.0.0.1/host.docker.internal/g' $HOME/.kube/kind-config-kind
  fi
  export KUBECONFIG=$HOME/.kube/kind-config-kind
}

function kctx() {
  if [ -z $1 ]; then
    kubectl config get-contexts
  else
    kubectl config use-context $1
  fi
}

function klogs() {
  kubectl logs -f $(kubectl get pods | awk "/$1/ {print \$1;exit}")
}

function parse_k8s_status() {
  ctx=`kubectl config current-context 2> /dev/null`
  if [ $? -eq 0 ] ; then
    echo "$ctx `kubectl config view --minify --output 'jsonpath={..namespace}'`"
  fi
}
