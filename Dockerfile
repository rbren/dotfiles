FROM ubuntu:latest

ENV TZ="America/New_York"

ARG DEBIAN_FRONTEND="noninteractive"
ARG GITHUB_ACCESS_TOKEN="none"
ARG SSH_PRIVATE_KEY
ENV USER=rbren
ENV SHELL=/bin/bash
ENV ARCH_STRING="arm64"
ENV TERM=xterm-256color

RUN apt-get update
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y sudo openssh-client git

RUN useradd -ms /bin/bash rbren
RUN usermod -aG sudo rbren
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN sudo usermod -aG docker rbren
RUN newgrp docker

RUN mkdir /setup && chown rbren /setup
RUN mkdir /home/rbren/.tmux && chown rbren /home/rbren/.tmux

USER rbren
RUN mkdir /home/rbren/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /home/rbren/.ssh/id_rsa
RUN chmod 600 /home/rbren/.ssh/id_rsa
RUN eval `ssh-agent -s` && ssh-add /home/rbren/.ssh/id_rsa
RUN ssh-keyscan github.com >> /home/rbren/.ssh/known_hosts

WORKDIR /devbox-init

COPY --chown=rbren ./dotfiles/.tool-versions ./dotfiles/.tool-versions

COPY --chown=rbren ./setup/languages.sh ./setup/languages.sh
RUN ./setup/languages.sh
COPY --chown=rbren ./setup/utils.sh ./setup/utils.sh
RUN ./setup/utils.sh
COPY --chown=rbren ./setup/git.sh ./setup/git.sh
RUN ./setup/git.sh
COPY --chown=rbren ./setup/vim.sh ./setup/vim.sh
RUN ./setup/vim.sh
COPY --chown=rbren ./setup/ops.sh ./setup/ops.sh
RUN ./setup/ops.sh
COPY --chown=rbren ./setup/fairwinds.sh ./setup/fairwinds.sh
RUN ./setup/fairwinds.sh

COPY --chown=rbren ./dotfiles ./dotfiles
COPY --chown=rbren ./setup/dotfiles.sh ./setup/dotfiles.sh
RUN ./setup/dotfiles.sh

RUN rm /home/rbren/.ssh/id_rsa

WORKDIR /home/rbren
CMD tmux -u
