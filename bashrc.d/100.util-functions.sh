function replaceall() {
  find "${1}" -type f -exec sed -i -e "${2}" {} \;
}

function prettyjson() {
  python -m json.tool $1 > /tmp/temp.json
  mv /tmp/temp.json $1
}

function percentmemoryused() {
  free | grep Mem | awk '{print $3/$2 * 100.0}'
}

function percentcpuused() {
  top -bn2 -d1 | grep "Cpu(s)" |  tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

function unistat() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date -jf "%m/%d/%Y %H:%M:%S" "`GetFileInfo -m $1`" +"%s"
  else
    stat -c %Y $1
  fi
}
