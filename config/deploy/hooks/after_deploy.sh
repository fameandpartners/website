#!/bin/bash

# Loading all the services helpers.
# Don't touch this line
. ${current_app_path}/config/deploy/hooks/services/load.sh

cd ${current_app_path} ; bundle exec rake cache:clear

# Zero Downtime Deploy
restart_unicorn
wheneverize_worker
