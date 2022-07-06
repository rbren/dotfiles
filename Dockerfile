FROM ubuntu:latest

ENV TZ="America/New_York"

ARG DEBIAN_FRONTEND="noninteractive"
ARG GITHUB_ACCESS_TOKEN="none"
ARG SSH_PRIVATE_KEY
ARG USER_NAME
ARG USER_ID
ENV SHELL=/bin/bash
ENV ARCH_STRING="arm64"
ENV TERM=xterm-256color
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y sudo openssh-client git

RUN useradd -ms /bin/bash -u $USER_ID $USER_NAME
RUN usermod -aG sudo $USER_NAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN groupadd docker
RUN sudo usermod -aG docker $USER_NAME
RUN newgrp docker

RUN mkdir /setup && chown $USER_NAME /setup
RUN mkdir /home/$USER_NAME/.tmux && chown $USER_NAME /home/$USER_NAME/.tmux

USER $USER_NAME
ENV USER=$USER_NAME
RUN mkdir /home/$USER_NAME/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /home/$USER_NAME/.ssh/id_rsa
RUN chmod 600 /home/$USER_NAME/.ssh/id_rsa
RUN eval `ssh-agent -s` && ssh-add /home/$USER_NAME/.ssh/id_rsa
RUN ssh-keyscan github.com >> /home/$USER_NAME/.ssh/known_hosts

WORKDIR /devbox-init

COPY --chown=$USER_NAME ./dotfiles/.tool-versions ./dotfiles/.tool-versions
COPY --chown=$USER_NAME ./dotfiles/bashrc.d/151.node.sh ./dotfiles/bashrc.d/151.node.sh

COPY --chown=$USER_NAME ./setup/installers.sh ./setup/installers.sh
RUN ./setup/installers.sh
COPY --chown=$USER_NAME ./setup/languages.sh ./setup/languages.sh
RUN ./setup/languages.sh
COPY --chown=$USER_NAME ./setup/utils.sh ./setup/utils.sh
RUN ./setup/utils.sh
COPY --chown=$USER_NAME ./setup/git.sh ./setup/git.sh
RUN ./setup/git.sh
COPY --chown=$USER_NAME ./setup/vim.sh ./setup/vim.sh
RUN ./setup/vim.sh
COPY --chown=$USER_NAME ./setup/ops.sh ./setup/ops.sh
RUN ./setup/ops.sh
COPY --chown=$USER_NAME ./setup/fairwinds.sh ./setup/fairwinds.sh
RUN ./setup/fairwinds.sh

COPY --chown=$USER_NAME ./dotfiles ./dotfiles
COPY --chown=$USER_NAME ./setup/dotfiles.sh ./setup/dotfiles.sh
RUN ./setup/dotfiles.sh

RUN rm /home/$USER_NAME/.ssh/id_rsa

WORKDIR /home/$USER_NAME
CMD sudo chown $USER /var/run/docker.sock && tmux -u
