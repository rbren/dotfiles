rbren's dotfiles
=======

Useful setups for
* bash
* vim
* tmux

## Moving to a new machine
> These are instructions for future me
* Clone this repo
* Run ./setup.sh
* Run `source ~/.bashrc`
* Copy your `~/.aws/credentials`
* Copy your `~/.ssh/github` and `~/.ssh/github.pub`

## Running in Docker on Mac M1
```
docker build --platform linux/arm64 \
  --build-arg GITHUB_ACCESS_TOKEN=$GITHUB_ACCESS_TOKEN \
  --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/github)" \
  --build-arg USER_NAME=$USER \
  --build-arg USER_ID=$UID \
  -t devstation .

docker run -it \
  --platform linux/arm64 \
  --privileged \
  --add-host=host.docker.internal:host-gateway \
  -v $HOME/git/:/home/rbren/git/ \
  -v $HOME/dockerstate/.bash_history.d:/home/rbren/.bash_history.d \
  -v $HOME/dockerstate/.local-bashrc:/home/rbren/.local-bashrc \
  -v $HOME/dockerstate/tmux-resurrect:/home/rbren/.tmux/resurrect \
  -v $HOME/dockerstate/direnv-allow:/home/rbren/.local/share/direnv/allow/ \
  -v $HOME/dockerstate/kind-config-kind:/home/rbren/.kube/kind-config-kind \
  -v $HOME/.awsvault:/home/rbren/.awsvault \
  -v $HOME/.ssh/:/home/rbren/.ssh/ \
  -v $HOME/.gnupg:/home/rbren/.gnupg \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 3000-4000:3000-4000 \
  --memory=100g --cpus=4 \
  devstation
```
