if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

pane_id_prefix="resurrect_"

HISTS_DIR=$HOME/.bash_history.d
mkdir -p "${HISTS_DIR}"

if [ -n "${TMUX_PANE}" ]; then
  pane_id=$(tmux display-message -p '#{pane_title}')
  if [[ $pane_id != "$pane_id_prefix"* ]]; then
    printf "\033]2;$pane_id_prefix`randstr 16`\033\\"
    pane_id=$(tmux display-message -p '#{pane_title}')
  fi
  export HISTFILE="${HISTS_DIR}/bash_history_tmux_${pane_id}"
else
  export HISTFILE="${HISTS_DIR}/bash_history_no_tmux"
fi
