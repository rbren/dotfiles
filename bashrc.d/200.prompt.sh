function grab_exit_code() {
  last_exit_code="$?"
}

function set_prompt() {
  echo "exited $last_exit_code"
  git_status=$(parse_git_status)

  os=$'\uf31b'
  #indicator=$os TODO: unicode screws up tmux
  indicator=👍
  indicator_color=$COLOR_GREEN
  if [ $last_exit_code -ne 0 ] && [ $last_exit_code -ne 130 ]; then
    indicator="👎 $last_exit_code"
    indicator_color=$COLOR_RED
  fi

  CUR_DIR=`pwd`
  if [[ $CUR_DIR == $GO_MAIN_DIR* ]]; then
    CUR_DIR=${CUR_DIR#"$GO_MAIN_DIR"}
    CUR_DIR="~GO$CUR_DIR"
  fi
  if [[ $CUR_DIR == $HOME* ]]; then
    CUR_DIR=${CUR_DIR#"$HOME"}
    CUR_DIR="~$CUR_DIR"
  fi
  setweather >> /dev/null # putting this in tmux instead of prompt, but refresh here
  source ~/bashrc.d/110.kube-ps1.sh
  FULL_PROMPT="$indicator_color$indicator ${COLOR_PURPLE}${CUR_DIR} ${git_status} $COLOR_NC$(kube_ps1) $COLOR_LIGHT_BLUE\n\$ "
  PS1=$FULL_PROMPT
  trap '[[ -t 1 ]] && tput sgr0' DEBUG
  history -a
}


