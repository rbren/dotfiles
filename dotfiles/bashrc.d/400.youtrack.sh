function yti() {
  usage="Specify a type, title, and (optionally) description. Examples:\nyti bug 'this is broken'\nor\nyti task 'do a thing' 'this thing needs to get done'"
  if [[ -z $YOUTRACK_TOKEN ]]; then
    echo "Please set YOUTRACK_TOKEN"
    return 1
  fi
  if [[ -z $YOUTRACK_PROJECT_ID ]]; then
    echo "Please set YOUTRACK_PROJECT_ID"
    return 2
  fi
  if [[ -z $YOUTRACK_USERNAME ]]; then
    echo "Please set YOUTRACK_PROJECT_ID"
    return 2
  fi
  if [[ -z $1 ]]; then
    echo -e $usage
    return 3
  fi
  if [[ -z $2 ]]; then
    echo -e $usage
    return 4
  fi
  type=$(echo ${1^l})
  title="${2}"
  description="${3}"

  read -r -d '' payload << EOM
  {
      "project":{"id":"$YOUTRACK_PROJECT_ID"},
      "summary":"${title}",
      "description":"${description}",
      "customFields": [{
        "name": "Assignee",
        "\$type": "SingleUserIssueCustomField",
        "value": {"login":"$YOUTRACK_USERNAME"}
      }, {
        "name": "Type",
        "\$type": "SingleUserIssueCustomField",
        "value": {"name":"${type}"}
      }]
  }
EOM

  response=$(curl -s -X POST \
    https://fairwinds.myjetbrains.com/youtrack/api/issues \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $YOUTRACK_TOKEN" \
    -d "${payload}")
  id=$(echo $response | sed 's/.*"id":"\([0-9a-zA-Z-]\+\)",.*/\1/')

  response2=$(curl -s \
    "https://fairwinds.myjetbrains.com/youtrack/api/issues/${id}?fields=idReadable" \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer $YOUTRACK_TOKEN")
  idReadable=$(echo $response2 | sed 's/.*"idReadable":"\([0-9a-zA-Z-]\+\)",.*/\1/')
  echo $idReadable
}
