FROM ubuntu:latest

ENV TZ="America/New_York"
ARG DEBIAN_FRONTEND="noninteractive"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y sudo

RUN useradd -ms /bin/bash rbren
RUN usermod -aG sudo rbren
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir /setup
RUN chown rbren /setup

USER rbren
COPY --chown=rbren ./dotfiles /setup/dotfiles
COPY --chown=rbren ./setup.sh /setup/setup.sh
WORKDIR /setup
RUN /setup/setup.sh

WORKDIR /home/rbren
CMD tmux -u
