#!/bin/bash

# # Loading all the services helpers.
# # Don't touch this line
# . ${current_app_path}/config/deploy/hooks/services/load.sh

# soft_stop_sidekiq
# # or
# stop_delayed_job
# # or
# stop_resque

# Alert #dev channel about deployments on staging
if ([ "${FRAMEWORK_ENV}" == "staging" ]) ; then
  slack_endpoint='https://hooks.slack.com/services'
  curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
  -X POST \
  --data-urlencode "payload={\"channel\":\"#dev\",\"username\":\"FameBot\",\"icon_emoji\":\":rocket:\",\"link_names\":\"1\",\"text\":\"@here, Deploying to *${SERVER_ROLE} ${FRAMEWORK_ENV}* - ${git_branch} (${remote_sha:0:6})\"}"
fi

if ([ "${SERVER_ROLE}" == "web" ] && ["${FRAMEWORK_ENV}" == "production" ]) ; then
  slack_endpoint='https://hooks.slack.com/services'

  previous_tag="$(git -C $APP_LOCATION/cached-copy/$APP_NAME/.git describe --tags --abbrev=0 HEAD^)"
  latest_tag="$(git -C $APP_LOCATION/cached-copy/$APP_NAME/.git describe --tags --abbrev=0)"
  message_diff="$(git -C $APP_LOCATION/cached-copy/$APP_NAME/.git diff --name-only $previous_tag..$latest_tag)"
  message_changes="$(git -C $APP_LOCATION/cached-copy/$APP_NAME/.git log $previous_tag..$latest_tag | awk 'match($0, /#[0-9]+/) { print substr( $0, RSTART, RLENGTH )}'|sed -E 's:(#):\ \* https\:\/\/github.com\/fameandpartners\/website\/pull\/:')"
  channel='#dev'
  author='DeployBot'

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
        "value": "$message_changes",
        "short": false
      },{
        "title": "Diff",
        "value": "\`\`\`$message_diff\`\`\`",
        "short": false,
        "mrkdwn": true
      },{
        "title": "Deploy Tag",
        "value": "\`$latest_tag\`",
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
