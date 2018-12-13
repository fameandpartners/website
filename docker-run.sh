#!/usr/bin/env bash

# Exit if error
set -e

############ Output ############
log_date_format='%Y-%m-%d %H:%M:%S'
function info() { echo $(green)[$(date +"$log_date_format")][I]  $*$(normal); }

function normal  { tput sgr0;    }
function green   { tput setaf 2; }

function kill_pid() {
  info "Attempting to kill for PID: $1"
  if [ -f $1 ]; then
    kill $(cat $1)
    info "Deleting: $1"
    rm $1
  fi
}

function mv_if_exists() {
  info "mv_if_exists: $1 $2"

  if [ -f $1 ]; then
    if [ -f $2 ]; then
      info "Both found, removing old: $1 $2"
      rm $2
    fi

    info "Moving $1 to $2"
    mv $1 $2
  fi
}

function rm_if_exists() {
  info "rm_if_exists: $1"

  if [ -f $1 ]; then
    info "Found: $1, now deleting"
    rm $1
  fi
}

function mkdir_if_not_exists() {
  info "mkdir_if_not_exists: $1 $2"

  if [ ! -d $1 ]; then
    info "Dir does not exist... creating"
    mkdir $1
  elif [ -n "$2" ]; then
    info "Dir already exists... clearing"
    rm -rf $1/*
  fi
}

# Clear out and creater required folders
mkdir_if_not_exists "/app/tmp"
mkdir_if_not_exists "/app/tmp/pids" 
mkdir_if_not_exists "/app/tmp/logs" y
mkdir_if_not_exists "/app/logs" y

# Test for redis
# if [ -z "${REDIS_IP}" ]; then
#   (printf "PING\r\n"; sleep 1) | nc $REDIS_IP 6379
# fi


# Copy over the production database config if not already so
mv_if_exists /app/config/database_production.yml /app/config/database.yml

cmd=""

if [ "${RAILS_TYPE}" == "worker" ]; then
  kill_pid /app/tmp/pids/sidekiq.pid

  mv_if_exists /app/config/sidekiq_production.yml /app/config/sidekiq.yml

  info "Running sidekiq"
  cmd="/app/bin/sidekiq -C /app/config/sidekiq.yml -e ${RAILS_ENV}"

else

  kill_pid /app/tmp/pids/unicorn.pid
  kill_pid /app/tmp/unicorn.pid
  kill_pid /app/tmp/pids/server.pid

  # Copy over the production unicorn config if not already so
  if  [ "$RAILS_ENV" != "development" ]; then
    mv_if_exists /app/config/unicorn_production.rb /app/config/unicorn.rb
  fi

  export PGPASSWORD=$DBPASSWORD

  # Run db commands
  if psql -U $DBUSER -h $DBHOST -lqt | cut -d \| -f 1 | grep -qw $DBNAME; then
    # database exists
    # $? is 0
    info "DB Already exists, running migration"
    bundle exec rake db:migrate
  else
    # ruh-roh
    # $? is 1
    info "DB missing, running create"
    bundle exec rake db:create db:schema:load db:migrate --trace

    #  Clear cache
    info "Running cache:clear in background daemon"
    nohup bundle exec rake cache:clear &
  fi

  if [ -n "${ASSET_SYNC_ENABLE}" ]; then
    info "Running assets:sync in background daemon"
    nohup bundle exec rake assets:sync &
  fi

  info "Running web"
  cmd="/app/bin/unicorn -c /app/config/unicorn.rb -E ${RAILS_ENV}"

  # Setup log redirection
  ln -sf /dev/stdout "/app/log/${RAILS_ENV}.log"

fi

info "Executing: bundle exec $cmd"
exec bundle exec "$cmd"
