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
  SERVER_NAME=$(echo $APP_HOST | awk '{ match($1, /https:\/\/([a-z0-9]+)?.fameandpartners.com/, res) }END{ print res[1] }')
  slack_endpoint='https://hooks.slack.com/services'

  curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
  -X POST \
  --data-urlencode "payload={\"channel\":\"#dev\",\"username\":\"FameBot\",\"icon_emoji\":\":rocket:\",\"link_names\":\"1\",\"text\":\"@here, Deploying to *${SERVER_ROLE} ${SERVER_NAME:-staging}(${FRAMEWORK_ENV})* - ${git_branch} (${requested_sha:0:6})\"}"
fi

