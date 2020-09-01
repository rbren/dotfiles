export GIT_STATUS_DEBUG=0
git config --global credential.helper 'cache --timeout=3000'

alias gits='git status'
alias gitc='git commit -m'
alias gitp='git push'
alias gitall='git commit -a -m'
alias gitaddall='git add . && git commit -m'
alias gitamend='git commit -a --amend --no-edit'
alias gitempty='git commit --allow-empty -m "empty commit"'
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

function maybe_refresh_git_fetch () {
  last_fetch=$(unistat .git/FETCH_HEAD)
  time_now=$(date +%s)
  timeout=60
  if [[ $((time_now - timeout)) -gt $((last_fetch)) ]]; then
    quiet_git fetch &
  fi
}

clean_color="$(tput setaf $TPUT_GREEN)"
changes_color="$(tput setaf $TPUT_YELLOW)"
dirty_color="$(tput setaf $TPUT_RED)"
unknown_indicator="$changes_color?"
behind_master_indicator="$dirty_color↓"
conflict_indicator="$dirty_color↕"
behind_indicator="$clean_color↓"
ahead_indicator="$clean_color↑"
new_branch_indicator="$changes_color↑"
clean_indicator="$clean_color✓"

function parse_git_status () {
  git_status="$(quiet_git status 2> /dev/null)"
  if [ $? -ne 0 ]; then
    return
  fi

  maybe_refresh_git_fetch
  quiet_git rev-parse --git-dir &> /dev/null
  branch="$(parse_git_branch 2> /dev/null)"
  dirty_status="Changes not staged"
  clean_status="working (.*) clean"
  if [[ ${git_status} =~ ${clean_status} ]]; then
    branch_color=$clean_color
  elif [[ ${git_status} =~ ${dirty_status} ]]; then
    branch_color=$dirty_color
  else
    branch_color=$changes_color
  fi

  if [[ ${branch} =~ " detached " || ${branch} =~ "no branch" || -z "$(quiet_git remote -v)" || -z "$(quiet_git branch --format='%(upstream)' --list master)" ]]; then
    status_indicator=$unknown_indicator
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
      status_indicator=$behind_master_indicator
    elif [[ ${behind_branch} -ne 0 && ${ahead_branch} -ne 0 ]]; then
      status_indicator=$conflict_indicator
    elif [[ ${behind_branch} -ne 0 ]]; then
      status_indicator=$behind_indicator
    elif [[ ${ahead_branch} -ne 0 ]]; then
      if [[ ${branch_exists} -eq 1 ]]; then
        status_indicator=$ahead_indicator
      else
        status_indicator=$new_branch_indicator
      fi
    else
      status_indicator=$clean_indicator
    fi
  fi
  echo "$branch_color$branch ${status_indicator}"
}
