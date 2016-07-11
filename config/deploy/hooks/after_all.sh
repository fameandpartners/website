#!/bin/bash

# # Loading all the services helpers.
# # Don't touch this line
# . ${current_app_path}/config/deploy/hooks/services/load.sh

git_revision_tag=`cd ${current_app_path} && git describe --tags`

if [ "${SERVER_ROLE}" == "web" ] ; then

  # Alert Sentry about deploy
  sentry_endpoint='https://app.getsentry.com/api/hooks'
  curl ${sentry_endpoint}/release/builtin/${SENTRY_PUBLIC_KEY}/${SENTRY_PRIVATE_KEY}/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{'version': '${git_revision_tag}'}"
fi

# Alert Slack about deploy
slack_endpoint='https://hooks.slack.com/services'
curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
-X POST \
--data-urlencode "payload={'channel':'#development','username':'FameBot','icon_emoji':':dancer:','text':'*Sentinel* started deploying ${git_revision_tag} to *${SERVER_ROLE} ${FRAMEWORK_ENV}*'}"
