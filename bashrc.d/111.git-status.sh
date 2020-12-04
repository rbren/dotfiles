clean_color="$(tput setaf $TPUT_GREEN)"
changes_color="$(tput setaf $TPUT_YELLOW)"
dirty_color="$(tput setaf $TPUT_RED)"
unknown_indicator="$changes_color🤔"
behind_main_indicator="$dirty_color↓"
conflict_indicator="$dirty_color↕"
behind_indicator="$clean_color↓"
ahead_indicator="$clean_color↑"
new_branch_indicator="$changes_color↑"
clean_indicator="$clean_color✨"

function gitdebug() {
    echo -e "$1  \t$(date -u +%s.%N)" >> ~/ps1-status-debug.txt
}

function quiet_git() {
  GIT_TERMINAL_PROMPT=0 git "$@" 2> /dev/null
}

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function parse_git_status () {
  git_status="$(quiet_git status 2> /dev/null)"
  if [ $? -ne 0 ]; then
    return
  fi
  main_branch=${GIT_MAIN_BRANCH:-"main"}

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

  if [[ ${branch} =~ " detached " || ${branch} =~ "no branch" || -z "$(quiet_git remote -v)" || -z "$(quiet_git branch --format='%(upstream)' --list $main_branch)" ]]; then
    status_indicator=$unknown_indicator
  else
    branch_exists="0"
    branch_status="$(quiet_git rev-list --left-right --count origin/$main_branch...$branch)"
    behind_main="$(echo $branch_status | sed '$s/  *.*//')"
    if [[ -n "$(quiet_git branch --format='%(upstream)' --list $branch)" ]]; then
      branch_status="$(quiet_git rev-list --left-right --count origin/$branch...$branch)"
      branch_exists="1"
    fi

    behind_branch="$(echo $branch_status | sed '$s/  *.*//')"
    ahead_branch="$(echo $branch_status | sed '$s/.*  *//')"

    if [[ ${behind_main} -ne 0 && ${branch} != "$main_branch" ]]; then
      status_indicator=$behind_main_indicator
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

