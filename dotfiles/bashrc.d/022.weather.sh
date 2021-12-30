weather() {
  curl -s https://wttr.in/${1:-boston} --max-time 5;
};
weathermoji() {
  curl -s "https://wttr.in/${1:-boston}?format=%c&period=60" --max-time 5;
};
setweather() {
  last_fetch=$(unistat ~/.weather)
  time_now=$(date +%s)
  if [[ $((time_now - 3600)) -gt $((last_fetch)) ]]; then
    weathermoji > ~/.weather
  fi
  cat ~/.weather
}

