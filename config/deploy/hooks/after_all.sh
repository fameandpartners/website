#!/bin/bash

# # Loading all the services helpers.
# # Don't touch this line
# . ${current_app_path}/config/deploy/hooks/services/load.sh

if ([ "${SERVER_ROLE}" == "web" ] && [ "${FRAMEWORK_ENV}" == "production" ]) ; then
  # Alert Sentry about deploy
  sentry_endpoint='https://app.getsentry.com/api/hooks'
  curl ${sentry_endpoint}/release/builtin/${SENTRY_PUBLIC_KEY}/${SENTRY_PRIVATE_KEY}/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"version\": \"${requested_sha}\"}"
fi

# Alert Slack about deploy
slack_endpoint='https://hooks.slack.com/services'
curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
-X POST \
--data-urlencode "payload={\"channel\":\"#dev-robots\",\"username\":\"FameBot\",\"icon_emoji\":\":dancer:\",\"text\":\"Successfully deployed to *${SERVER_ROLE} ${FRAMEWORK_ENV}* - ${git_branch} (${requested_sha:0:6})\"}"

