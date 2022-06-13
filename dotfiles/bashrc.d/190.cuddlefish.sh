if [ -f ~/.cuddlefish/config ]; then
        . ~/.cuddlefish/config
fi

export AWS_VAULT_BACKEND=file
export CUDDLEFISH_PROJECTS_DIR="$HOME/workspace/projects"
export NO_CD="True"
export BASTION_USERNAME=rbren
alias cc='cuddlectl'


