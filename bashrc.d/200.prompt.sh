function grab_exit_code() {
  last_exit_code="$?"
  now=$(date -u +%s)
  last_execution_time=$(HISTTIMEFORMAT='%s '; history 1)
  last_execution_time=$(awk '{print $2}' <<<"$last_execution_time");
  last_execution_duration=$(( now - last_execution_time ))
  prompt_start_time=$(date -u +%s%N)
}

function set_prompt() {
  git_status=$(parse_git_status)
  _kube_ps1_update_cache

  os=$'\uf31b'
  #indicator=$os TODO: unicode screws up tmux
  indicator=👍
  if [ $last_exit_code -ne 0 ] && [ $last_exit_code -ne 130 ]; then
    indicator="😡 $last_exit_code"
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
  trap '[[ -t 1 ]] && tput sgr0' DEBUG
  history -a
  end_time=$(date -u +%s%N)
  prompt_duration=$(((end_time - prompt_start_time) / 1000000))
  FULL_PROMPT="$indicator $(tput setaf $TPUT_GREEN)[${last_execution_duration}s]"
  if [ $GIT_STATUS_DEBUG -eq 1 ]; then
    FULL_PROMPT="$FULL_PROMPT [${prompt_duration}ms]"
  fi
  FULL_PROMPT="$FULL_PROMPT $(kube_ps1)"
  FULL_PROMPT="$FULL_PROMPT $(tput setaf $TPUT_MAGENTA)${CUR_DIR} ${git_status} $(tput sgr0)$(tput bold)$(tput setaf $TPUT_BLUE)\n\$ "
  PS1="$(tput setab $TPUT_BLACK)$(tput bold)$FULL_PROMPT"
}


