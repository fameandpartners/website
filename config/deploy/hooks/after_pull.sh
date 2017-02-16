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
      "image_url": "https://media.giphy.com/media/Yip9sdlVQqkUg/giphy.gif",
      "footer": "By $author",
      "ts": "$(date +%s)"
    }]
  }
EOJ)

  curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
    -X POST \
    --data-urlencode "payload=$json_message"
fi
