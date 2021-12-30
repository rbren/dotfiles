if [ -n $SSH_AGENT_PID ]; then
  kill $SSH_AGENT_PID
fi
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github


