export GIT_STATUS_DEBUG=0
git config --global credential.helper 'cache --timeout=3000'

alias gitc='git commit -a -m'
alias gita='git commit -a --amend --no-edit'
alias gitop='git push -u origin  $(parse_git_branch 2> /dev/null)'
alias gitfp='git push -u origin +$(parse_git_branch 2> /dev/null)'

function gitbd() {
  git branch -D `git branch | grep -E $1`
}

function gitcleanbranch() {
  current_branch=parse_git_branch
  while read -r line ; do
    if [[ $line == $current_branch ]]; then
      continue
    fi

    set +e
    git branch -D $line 2> /dev/null
    if [ $? -eq 0 ]; then
      echo "deleted $line"
    fi
    set -e
  done < <(git remote prune origin --dry-run | grep "would prune" | sed -e 's/.* \[would prune\] origin\///')
}

function gitdebug() {
  if [ $GIT_STATUS_DEBUG -eq 1 ]; then
    echo -e "$1  \t$(date -u +%s.%N)" >> ~/ps1-status-debug.txt
  fi
}

function quiet_git() {
  gitdebug $1
  GIT_TERMINAL_PROMPT=0 git "$@" 2> /dev/null
}

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function gitup () {
  branch="$(parse_git_branch 2> /dev/null)"
  git checkout master && git pull && git checkout $branch && git rebase master
}

function ghc() {
  git clone "ssh://git@github.com/$1" $2
}

function gitcheck() {
  for dir in ~/git/*; do
    gitstat=`cd $dir && parse_git_status`
    gitstat=$COLOR_NC$gitstat$COLOR_NC
    gitstat=${gitstat//\\[/}
    gitstat=${gitstat//\\]/}
    (cd "$dir" && echo -e "$gitstat: $dir")
  done
}

function parse_git_status () {
  if ! [ -d ".git" ]; then
    return
  fi
  gitdebug "\nstart  "
  quiet_git rev-parse --git-dir &> /dev/null
  gitdebug "gps1    "
  branch="$(parse_git_branch 2> /dev/null)"
  git_status="$(quiet_git status 2> /dev/null)"
  dirty_status="Changes not staged"
  clean_status="working (.*) clean"
  if [[ ${git_status} =~ ${clean_status} ]]; then
    branch_color="$(tput setaf $TPUT_GREEN)"
  elif [[ ${git_status} =~ ${dirty_status} ]]; then
    branch_color="$(tput setaf $TPUT_RED)"
  else
    branch_color="$(tput setaf $TPUT_YELLOW)"
  fi
  gitdebug "unistat"
  last_fetch=$(unistat .git/FETCH_HEAD)
  time_now=$(date +%s)
  timeout=60
  if [[ $((time_now - timeout)) -gt $((last_fetch)) ]]; then
    quiet_git fetch
  fi
  gitdebug "bstatus"
  if [[ ${branch} =~ " detached " || ${branch} =~ "no branch" || -z "$(quiet_git remote -v)" || -z "$(quiet_git branch --format='%(upstream)' --list master)" ]]; then
    status_indicator="$(tput setaf $TPUT_YELLOW)?"
  else
    branch_exists="0"
    branch_status="$(quiet_git rev-list --left-right --count origin/master...$branch)"
    behind_master="$(echo $branch_status | sed '$s/  *.*//')"
    if [[ -n "$(quiet_git branch --format='%(upstream)' --list $branch)" ]]; then
      branch_status="$(quiet_git rev-list --left-right --count origin/$branch...$branch)"
      branch_exists="1"
    fi

    behind_branch="$(echo $branch_status | sed '$s/  *.*//')"
    ahead_branch="$(echo $branch_status | sed '$s/.*  *//')"

    if [[ ${behind_master} -ne 0 && ${branch} != "master" ]]; then
      status_indicator="$(tput setaf $TPUT_RED)↓"
    elif [[ ${behind_branch} -ne 0 && ${ahead_branch} -ne 0 ]]; then
      status_indicator="$(tput setaf $TPUT_RED)↕"
    elif [[ ${behind_branch} -ne 0 ]]; then
      status_indicator="$(tput setaf $TPUT_BLUE)↓"
    elif [[ ${ahead_branch} -ne 0 ]]; then
      if [[ ${branch_exists} -eq 1 ]]; then
        status_indicator="$(tput setaf $TPUT_BLUE)↑"
      else
        status_indicator="$(tput setaf $TPUT_YELLOW)↑"
      fi
    else
      status_indicator="$(tput setaf $TPUT_GREEN)✓"
    fi
  fi
  echo "$branch_color$branch ${status_indicator}"
}
