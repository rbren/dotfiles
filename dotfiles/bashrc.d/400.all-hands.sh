function gke() {
  kconf_name="$HOME/.kube/$1-$2.kubeconfig"
  KUBECONFIG="$kconf_name" gcloud container clusters get-credentials $1 --zone us-central1 --project $2
  export KUBECONFIG=$kconf_name
}

alias gke-prod-app='gke prod-core-application production-092024'
alias gke-prod-run='gke prod-runtime production-092024'
alias gke-stag-app='gke staging-core-application staging-092024'
alias gke-stag-run='gke staging-runtime staging-092024'
alias gke-eval-app='gke eval-core-application evaluation-092024'
alias gke-eval-run='gke eval-runtime evaluation-092024'

