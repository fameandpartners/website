#!/bin/bash

# Loading all the services helpers.
# Don't touch this line
. ${current_app_path}/config/deploy/hooks/services/load.sh

# Zero Downtime Deploy
zdd_unicorn
wheneverize_worker


###############################
# Fame & Parters Dev Team Hooks
###############################

# Clear cache
echo "Clearing Application Cache"
cd ${current_app_path} && bundle exec rake cache:clear &

# Alert NewRelic about deploy
# TODO

# Alert Sentry about deploy
# TODO

# Alert Slack about deploy
# TODO
