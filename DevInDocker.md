# Dockerized Dev Environment
This develoment setup is mostly working inside of Docker.

## Features
* Shared state with host using `-v`
  * `~/git` directory, so project changes persist
  * file permissions are identical between docker and host user
  * credentials (AWS Vault, SSH, GPG)
  * direnv allowed environments
* DooD setup for Docker/KIND
* preserves tmux sessions

## Benefits
* Security - `npm install` doesn't have access to my entire Mac, side effects are wiped out
* Consistent dev environment
  * Modifications to global state are ephemeral
* Reproducible on a new machine
* Can constrain resources, so a dev process doesn't kill Zoom/Slack
* Can experiment and install things with minimal risk

## Known Issues and Limitations
* shell history in tmux sometimes gets out of sync
* unicode screws up the tmux status bar
* fairly long startup time (~30s)
* installing a new app takes much longer - needs a docker rebuild
* there's a layer in the `docker build` which has my SSH key - important not to publish
    * this is for cloning cuddlefish
* go modules have to download fresh after restart
  * can probably add $GOROOT to saved state?
* conda is not persisted
  * can probably add this to state

## Learnings
* UTF-8 is hard
* File permissions are hard
* DIND is hard
* networking is hard
* tmux is hard
* factoring your Dockerfile properly is important
* still don't know what cgroups are
* `asdf` is the best
* arm64 == aarch64?

## Running in Docker on Mac M1
```
docker build --platform linux/arm64 \
  --build-arg GITHUB_ACCESS_TOKEN=$GITHUB_ACCESS_TOKEN \
  --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/github)" \
  --build-arg USER_NAME=$USER \
  --build-arg USER_ID=$UID \
  -t devbox .

docker run -it \
  --platform linux/arm64 \
  --privileged \
  --network=host \
  --add-host=host.docker.internal:host-gateway \
  -v $HOME/devbox/.bash_history.d:/home/rbren/.bash_history.d \
  -v $HOME/devbox/.local-bashrc:/home/rbren/.local-bashrc \
  -v $HOME/devbox/tmux-resurrect:/home/rbren/.tmux/resurrect \
  -v $HOME/devbox/direnv-allow:/home/rbren/.local/share/direnv/allow/ \
  -v $HOME/devbox/kind-config-kind:/home/rbren/.kube/kind-config-kind \
  -v $HOME/devbox/.vault-token:/home/rbren/.vault-token \
  -v $HOME/git/:/home/rbren/git/ \
  -v $HOME/.awsvault:/home/rbren/.awsvault \
  -v $HOME/.ssh/:/home/rbren/.ssh/ \
  -v $HOME/.gnupg:/home/rbren/.gnupg \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 3000-4000:3000-4000 \
  --memory=100g --cpus=4 \
  devbox
```
