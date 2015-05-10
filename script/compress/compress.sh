#!/bin/sh

API_KEY="GNASbmooAPhDbMItn68FA3xyOhgXm5dL"

usage()
{
  cat <<EOF >&2
 `basename $0`: compress images in a directory recursively with tinypng API

sh ./`basename $0` [-h] <directory>
 	-h 		- print this message
	<directory>	- directory to compress
Examples:
sh ./`basename $0` "DROP 3"
EOF
  exit 0
}

# Gets and outputs to stdout the value from JSON (passed as <var>) for the given
# key.
# get_opt <var> <name>
get_opt()
{
  echo "$1" | awk -F"\t" '$1=="[\"'$2'\"]"{gsub(/"/,"",$2);print $2}'
}

while getopts "?" opt; do
  case $opt in
    ?) usage;;
  esac
done
shift $((OPTIND-1))

find "$1" -name \*.jpg -o -name \*.png |
  while read fn; do
    echo $fn
    out=$(curl -s --user api:$API_KEY --data-binary @"$fn" https://api.tinypng.com/shrink) || { echo "Error accessing API." >&2; exit 1; }
    res=$(echo "$out" | bash ./json.sh -l) || { echo "Error parsing resulting JSON: $out." >&2; exit 1; }
    err=$(get_opt "$res" error)
    if [ "$err" ]; then
      echo "$err: $(get_opt "$res" message)" >&2
      # exit 1
    fi
    loc=$(get_opt "$res" "output\\\",\\\"url")
    curl -s $loc > "$fn"
  done
