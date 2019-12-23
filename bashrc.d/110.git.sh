git config --global credential.helper 'cache --timeout=3000'

alias gitc='git commit -a -m'
alias gita='git commit -a --amend --no-edit'
alias gitop='git push -u origin  $(parse_git_branch 2> /dev/null)'
alias gitfp='git push -u origin +$(parse_git_branch 2> /dev/null)'
function gitbd() {
  git branch -D `git branch | grep -E $1`
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
  git clone "ssh://git@github.com/$1"
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
  git rev-parse --git-dir &> /dev/null
  branch="$(parse_git_branch 2> /dev/null)"
  git_status="$(git status 2> /dev/null)"
  status_pattern="working (.*) clean"
  if [[ ! ${git_status} =~ ${status_pattern} ]]; then
    branch_color="${COLOR_RED}"
  else
    branch_color="${COLOR_GREEN}"
  fi
  last_fetch=$(unistat .git/FETCH_HEAD)
  time_now=$(date +%s)
  timeout=60
  if [[ $((time_now - timeout)) -gt $((last_fetch)) ]]; then
    quiet_git fetch
  fi
  if [[ ${branch} =~ " detached " || ${branch} =~ "no branch" || -z "$(git remote -v)" || -z "$(quiet_git branch --format='%(upstream)' --list master)" ]]; then
    status_indicator="${COLOR_YELLOW}?"
  else
    branch_status="$(git rev-list --left-right --count origin/master...$branch)"
    behind_master="$(echo $branch_status | sed '$s/  *.*//')"
    branch_exists="0"
    if [[ -n "$(quiet_git branch --format='%(upstream)' --list $branch)" ]]; then
      branch_status="$(quiet_git rev-list --left-right --count origin/$branch...$branch)"
      branch_exists="1"
    fi

    behind_branch="$(echo $branch_status | sed '$s/  *.*//')"
    ahead_branch="$(echo $branch_status | sed '$s/.*  *//')"

    if [[ ${behind_branch} -ne 0 && ${ahead_branch} -ne 0 ]]; then
      status_indicator="${COLOR_RED}↕"
    elif [[ ${behind_branch} -ne 0 ]]; then
      status_indicator="${COLOR_LIGHT_BLUE}↓"
    elif [[ ${behind_master} -ne 0 && ${branch} != "master" ]]; then
      status_indicator="${COLOR_RED}↓"
    elif [[ ${ahead_branch} -ne 0 ]]; then
      if [[ ${branch_exists} -eq 1 ]]; then
        status_indicator="${COLOR_LIGHT_BLUE}↑"
      else
        status_indicator="${COLOR_YELLOW}↑"
      fi
    else
      status_indicator="${COLOR_GREEN}✓"
    fi
  fi
  echo "$branch_color$branch ${status_indicator}"
}
