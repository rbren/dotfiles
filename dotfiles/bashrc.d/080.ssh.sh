SSH_ENV="$HOME/.ssh/agent-env"

_start_ssh_agent() {
  ssh-agent -s > "$SSH_ENV"
  chmod 600 "$SSH_ENV"
  source "$SSH_ENV" > /dev/null
  ssh-add ~/.ssh/github 2>/dev/null
}

if [ -f "$SSH_ENV" ]; then
  source "$SSH_ENV" > /dev/null
  if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
    _start_ssh_agent
  fi
else
  _start_ssh_agent
fi


