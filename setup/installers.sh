#!/bin/bash
set -eo pipefail

echo "installing basic utils from apt"
sudo apt-get update
sudo apt-get install -y sudo cron vim curl build-essential git tmux direnv unzip software-properties-common libssl-dev snapd
sudo apt-get update

echo "installing asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
