function grab_exit_code() {
  last_exit_code="$?"
  now=$(date -u +%s)
  last_execution_time=$(HISTTIMEFORMAT='%s '; history 1)
  last_execution_time=$(awk '{print $2}' <<<"$last_execution_time");
  last_execution_duration=$(( now - last_execution_time ))
  prompt_start_time=$(nanodate)
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
  end_time=$(nanodate)
  prompt_duration=$(((end_time - prompt_start_time) / 1000000))
  FULL_PROMPT="$indicator $(tput setaf $TPUT_GREEN)[${last_execution_duration}s]"
  if [ $GIT_STATUS_DEBUG -eq 1 ]; then
    FULL_PROMPT="$FULL_PROMPT [${prompt_duration}ms]"
  fi
  FULL_PROMPT="$FULL_PROMPT $(kube_ps1)"
  FULL_PROMPT="$FULL_PROMPT $(tput setaf $TPUT_MAGENTA)${CUR_DIR} ${git_status}"
  no_colors=$(echo -e "$FULL_PROMPT" | sed "s/$(echo -e "\e")[^m]*m//g");
  prompt_len=${#no_colors}
  total_len=$(tput cols)
  # FIXME: why the extra 8 chars?
  SPACES=$(printf "=%.0s" $(seq $prompt_len $(( total_len + 8 ))))
  PS1="$(tput setab $TPUT_BLACK)$(tput bold)$FULL_PROMPT $(tput setaf $TPUT_GRAY)${SPACES}$(tput sgr0)$(tput bold)$(tput setaf $TPUT_BLUE)\n\$ "
}


