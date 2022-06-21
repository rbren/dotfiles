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
docker build --platform linux/amd64 \
  --build-arg GITHUB_ACCESS_TOKEN=$GITHUB_ACCESS_TOKEN \
  --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/github)" \
  -t devstation .

docker run -it \
  --platform linux/amd64 \
  -v $HOME/git/:/home/rbren/git/ \
  -v $HOME/dockerstate/.bash_history:/home/rbren/.bash_history \
  -v $HOME/dockerstate/.local-bashrc:/home/rbren/.local-bashrc \
  -v $HOME/dockerstate/tmux-ressurect:/home/rbren/.tmux/ressurect \
  -v $HOME/.awsvault:/home/rbren/.awsvault
  -v $HOME/.ssh/:/home/rbren/.ssh/ \
  -p 3000-4000:3000-4000 \
  --memory=100g --cpus=4 \
  devstation
```
