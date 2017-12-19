#!/bin/bash

# # Loading all the services helpers.
# # Don't touch this line
# . ${current_app_path}/config/deploy/hooks/services/load.sh

# Alert #dev channel about deployments on production
if ([ "${SERVER_ROLE}" == "web" ] && [ "${FRAMEWORK_ENV}" == "production" ]) ; then
  slack_endpoint='https://hooks.slack.com/services'

  git_folder="$git_cached_copy/.git"
  log_folder="/var/log/$app_full_name/deploys"
  log_file="$log_folder/latest_changes.log"

  previous_tag="$(git -C $git_folder describe --tags --abbrev=0 HEAD^)"
  latest_tag="$(git -C $git_folder describe --tags --abbrev=0 HEAD)"
  message_diff="$(git -C $git_folder diff --name-only $previous_tag..$latest_tag)"
  message_changes="$(git -C $git_folder log $previous_tag..$latest_tag | awk 'match($0, /#[0-9]+/) { print substr( $0, RSTART, RLENGTH )}'|sed -E 's:(#):\ \* https\:\/\/github.com\/fameandpartners\/website\/pull\/:')"
  channel='#dev'
  author='DeployBot'

  mkdir -p $log_folder

  if [ -d "$log_folder" ]; then
    echo "Latest deploy changes at: $(date)" > $log_file
    echo "Previous tag: $previous_tag" >> $log_file
    echo "Latest tag:   $latest_tag" >> $log_file

    echo >> $log_file
    echo 'Files changed:' >> $log_file
    echo "$message_diff" >> $log_file

    echo >> $log_file
    echo 'Merged PRs:' >> $log_file
    echo "$message_changes" >> $log_file
  fi

  # NOTE: Alexey Bobyrev 09 Feb 2017
  # Slack accepts only 4000 characters per message
  char_limit=1800

  gifs[0]='https://media0.giphy.com/media/b1coB1RqQGRUI/giphy.gif'
  gifs[1]='https://i.imgur.com/m31b3r0.gif'
  gifs[2]='https://media1.giphy.com/media/13I7q3kMjxtW9y/giphy.gif'
  gifs[3]='https://lh3.googleusercontent.com/WVfcsIpjtRCfnXmJQQ8ZTdcNFJ1hxlTH2A6eMCzT3cFEzRrWzG99Zmco5Wn3t8o6lMQM1dxv=w3360-h1700'
  gifs[4]='https://lh5.googleusercontent.com/OC1eXTMO-m6HZGZhgP-A8MzW9zZe8nyezBW07_ceddlm9f4k64-LNsyaEAdfi3YWIpkcXT2U=w3360-h1700'
  gifs[5]='https://lh6.googleusercontent.com/UP_wCgL627TT0L8thvu3FTQlBI34MGbe55kZEXLfyX8OtA272fr6TtvoK22OlncL5Q087pfM=w3360-h1700'
  gifs[6]='https://lh4.googleusercontent.com/7a3YAcVbmUYsLrMyqBDoaHdQYlq02_Iyrc-IyCTr8JPEUS3CAIZ8KXNYAxTXf62OyIzQjFIT=w3360-h1700'
  gifs[7]='https://lh3.googleusercontent.com/E0o5rcrEDEKU4TJVs4i9MoccpgqrZLPhskPxfMraN2c4RzgQFVlKXoGV7Z9BNhranI1kNasB=w3360-h1700'
  gifs[8]='https://lh6.googleusercontent.com/9NY59bjmeXDaugZJOHwxrsSXh3ZoVp6Fu1WJqPBj6GL2xs6UbQPNToHMaLonWvKChybhEbkn=w3360-h1700'
  gifs[9]='https://lh3.googleusercontent.com/fWnNEqtQPjhZ4YwmPF2JxeEKU-OY5LWab2gebAYyKw-SzJVF-L_75euAL5IQgud9TxCm6YxL=w3360-h1700'
  gifs[10]='https://s3-us-west-2.amazonaws.com/giffy-prod/95f886093e7d414f8b5a5d3b956e09ff.gif'
  gifs[11]='https://s3-us-west-2.amazonaws.com/giffy-prod/b95ccdcf03504c9ea6d241178d6e5353.gif'
  gifs[12]='https://s3-us-west-2.amazonaws.com/giffy-prod/80fb439877ae43cfaf25441e0a3e6ea8.gif'
  
  
rand_gif_number=$[ $RANDOM % 13 ]
echo ${gifs[$rand_gif_number]}

json_message=$(cat <<EOJ
  {
    "channel": "$channel",
    "username": "FameBot",
    "icon_emoji": ":shipit:",
    "link_names": 1,
    "attachments": [{
      "color": "#36a64f",
      "title": "",
      "text": "",
      "pretext": "@here Deploy production w/ latest changes.",
      "fallback": "Deploy production w/ latest changes.",
      "fields": [{
        "title": "Changes",
        "value": "${message_changes:0:$char_limit}",
        "short": false
      },{
        "title": "Diff",
        "value": "\`\`\`${message_diff:0:$char_limit}\`\`\`",
        "short": false,
        "mrkdwn": true
      },{
        "title": "Deploy Tag",
        "value": "\`$latest_tag\`",
        "short": false,
        "mrkdwn": true
      },{
        "title": "Full changeset list path on server",
        "value": "\`$log_file\`",
        "short": false,
        "mrkdwn": true
      }],
      "mrkdwn_in": [ "fields" ],
      "image_url": "${gifs[$rand_gif_number]}",
      "footer": "By $author",
      "ts": "$(date +%s)"
    }]
  }
EOJ
)

  curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
    -X POST \
    --data-urlencode "payload=$json_message"
fi
