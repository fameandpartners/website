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
  -d "{\"version\": \"${remote_sha}\"}"
fi

# Alert Slack about deploy
slack_endpoint='https://hooks.slack.com/services'
curl ${slack_endpoint}/T026PUF20/B046TP83D/${SLACK_API_KEY} \
-X POST \
--data-urlencode "payload={\"channel\":\"#dev-robots\",\"username\":\"FameBot\",\"icon_emoji\":\":dancer:\",\"text\":\"Successfully deployed to *${SERVER_ROLE} ${FRAMEWORK_ENV}* - ${git_branch} (${remote_sha:0:6})\"}"

# NOTE: Alexey Bobyrev 19/12/16
# Add the list of merged to staging branch tasks into public/deployed.html
# After deploy available to view by link: https://staging.fameandpartners.com/deployed
if ([ "${SERVER_ROLE}" == "web" ] && [ "${FRAMEWORK_ENV}" == "staging" ]) ; then
  FILE_PATH=$current_app_path/public/deployed.html
  ISSUES_LIST=$(git -C $APP_LOCATION/cached-copy/$APP_NAME/.git log --merges --grep='WEBSITE.\+staging' | awk 'match($0, /WEBSITE-[0-9]+/) { print substr( $0, RSTART, RLENGTH )}' )

  HEADER_TEXT="<h3>Deployed branches on <a href='https://staging.fameandpartners.com'>https://staging.fameandpartners.com</a></h3>"
  ISSUES_LIST_BEGIN_TEXT="<li><a href='https:\/\/fameandpartners.atlassian.net\/browse\/"
  ISSUES_LIST_END_TEXT="<\/a><\/li>"

  echo $HEADER_TEXT > $FILE_PATH
  echo '<ul>' >> $FILE_PATH
  echo $(echo $ISSUES_LIST | tr ' ' '\n' | sed "s/.*/$ISSUES_LIST_BEGIN_TEXT&'>&$ISSUES_LIST_END_TEXT/") >> $FILE_PATH
  echo '</ul>' >> $FILE_PATH
fi
