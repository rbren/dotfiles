FROM ubuntu:latest

ENV TZ="America/New_York"
ARG DEBIAN_FRONTEND="noninteractive"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y sudo

COPY . /setup
WORKDIR /setup
RUN /setup/setup.sh
