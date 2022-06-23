export IP_ADDRESS=$(curl -s http://whatismyip.akamai.com/ --max-time 5)

export IGNOREEOF=42

export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GOLD='\e[0;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'

export COLOR_BG_BLACK='\033[40m'
export COLOR_BG_RED='\033[41m'
export COLOR_BG_GREEN='\033[42m'
export COLOR_BG_YELLOW='\033[43m'
export COLOR_BG_BLUE='\033[44m'
export COLOR_BG_PURPLE='\033[45m'
export COLOR_BG_CYAN='\033[46m'
export COLOR_BG_WHITE='\033[47m'

export TPUT_COLORS=$(printf '\e[0m\e[48;5;%dm  %03d  ' {0..255}; printf '\e[0m \n')
export TPUT_BLACK="0"
export TPUT_RED="203"
export TPUT_GREEN="40"
export TPUT_YELLOW="3"
export TPUT_BLUE="4"
export TPUT_MAGENTA="164"
export TPUT_CYAN="50"
export TPUT_WHITE="7"
export TPUT_GRAY="242"
export TPUT_LIGHT_BLUE="38"

export KUBE_PS1_SYMBOL_ENABLE=false
export KUBE_PS1_PREFIX=""
export KUBE_PS1_SUFFIX=""
export KUBE_PS1_CTX_COLOR=$TPUT_CYAN
export KUBE_PS1_NS_COLOR=$TPUT_CYAN
export KUBE_PS1_DIVIDER=" "

export FIGNORE=".hi"

export PROMPT_COMMAND="_direnv_hook;maybe_git_fetch;history -a"
