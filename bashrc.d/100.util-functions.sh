function replaceall() {
  find "${1}" -type f -exec sed -i -e "${2}" {} \;
}

function prettyjson() {
  python -m json.tool $1 > /tmp/temp.json
  mv /tmp/temp.json $1
}

function percentmemoryfree() {
  free | grep Mem | awk '{print $3/$2 * 100.0}'
}


