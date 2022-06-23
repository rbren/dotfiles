if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

HISTS_DIR=$HOME/.bash_history.d
mkdir -p "${HISTS_DIR}"

if [ -n "${TMUX_PANE}" ]; then
  PANE=$(echo $TMUX_PANE | sed 's/%//g')
  export HISTFILE="${HISTS_DIR}/bash_history_tmux_${PANE}"
else
  export HISTFILE="${HISTS_DIR}/bash_history_no_tmux"
fi
