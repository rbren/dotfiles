#!/bin/bash
set -eo pipefail

crontab -l > ./cron-tmp || true
cat ./dotfiles/cron >> ./dotfiles/cron-tmp
crontab ./dotfiles/cron-tmp
rm ./dotfiles/cron-tmp


