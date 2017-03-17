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
  echo "Latest deploy changes at: $(date)" > $log_file
  echo "Previous tag: $previous_tag">> $log_file
  echo "Latest tag:   $latest_tag">> $log_file

  echo >> $log_file
  echo 'Files changed:' >> $log_file
  echo "$message_diff" >> $log_file

  echo >> $log_file
  echo 'Merged PRs:' >> $log_file
  echo "$message_changes" >> $log_file

  # NOTE: Alexey Bobyrev 09 Feb 2017
  # Slack accepts only 4000 characters per message
  char_limit=1800
  
gifs[0]='http://68.media.tumblr.com/tumblr_lgb02mCfLm1qe0eclo1_r5_500.gif'
gifs[1]='https://media.giphy.com/media/IzVwOO8xZsfks/giphy.gif'
gifs[2]='https://media.giphy.com/media/1FT20zgiDr8Bi/giphy.gif'
gifs[3]='https://media.giphy.com/media/E5Y1XC79e6Btm/giphy.gif'
gifs[4]='http://i.imgur.com/LZsRtcX.gif'
gifs[5]='https://s3-us-west-2.amazonaws.com/giffy-prod/e84eada496534922b22cb39cdbe566a4.gif'

rand_gif_number=$[ $RANDOM % 6 ]
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
EOJ)

  curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
    -X POST \
    --data-urlencode "payload=$json_message"
fi
