export GIT_STATUS_DEBUG=0
git config --global credential.helper 'cache --timeout=3000'

alias gits='git status'
alias gitp='git push'
alias gitaddall='git add . && git commit -m'
alias gita='git commit -a --amend --no-edit'
alias gitempty='git commit --allow-empty -m "empty commit"'
alias gitop='git push -u origin  $(parse_git_branch 2> /dev/null)'
alias gitfp='git push -u origin +$(parse_git_branch 2> /dev/null)'
alias gitnb='git checkout -b'
alias gitb='git checkout'

function gitc () {
  quoted_args=$(printf "${1+ %q}" "$@")
  git commit -m "$quoted_args"
}

function gitca () {
  msg=$(printf "${1+ %q}" "$@")
  msg="${msg##*( )}"
  git commit -a -m "$quoted_args"
}

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

function maybe_git_fetch () {
  if ! [ -d ".git" ]; then
    return
  fi
  last_fetch=$(unistat .git/FETCH_HEAD)
  time_now=$(date +%s)
  timeout=60
  if [[ $((time_now - timeout)) -gt $((last_fetch)) ]]; then
    (quiet_git fetch &)
  fi
}

