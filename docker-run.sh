#!/usr/bin/env bash

# Exit if error
set -e

############ Output ############
log_date_format='%Y-%m-%d %H:%M:%S'
function info() { echo [$(date +"$log_date_format")][I]  $*; }

LEADER_FNAME=/tmp/flag_leader

function kill_pid() {
  info "kill_pid: args => $1"
  if [ -f $1 ]; then
    pid=$(cat $1)
    kill $pid
    info "kill_pid: Killed pid: $pid from $1. Now deleting."
    rm $1
  fi
}

function mv_if_exists() {
  info "mv_if_exists: args => $1 $2"

  if [ -f $1 ]; then
    if [ -f $2 ]; then
      info "mv_if_exists: Found both files. Deleting the old file"
      rm $2
    fi

    info "mv_if_exists: Moving $1 to $2"
    mv $1 $2
  fi
}

function rm_if_exists() {
  info "rm_if_exists: args => $1"

  if [ -f $1 ]; then
    info "rm_if_exists: Found: $1, now deleting"
    rm $1
  fi
}

function mkdir_if_not_exists() {
  info "mkdir_if_not_exists: args => $1 $2"

  if [ ! -d $1 ]; then
    info "mkdir_if_not_exists: Creating $1"
    mkdir $1
  elif [ -n "$2" ]; then
    info "mkdir_if_not_exists: Clearing $1 of contents"
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

  # Setup CRONJOBs only on leader
  if [ -f "$LEADER_FNAME" ]; then
    info "Starting cron daemon"
    /etc/init.d/cron start

    # Setup whenever
    if [ -f "/app/bin/whenever" ]; then
      info "Starting whenever daemon"
      /app/bin/whenever --update-crontab "fame-${RAILS_ENV}" --set "environment=${RAILS_ENV}"
    fi
  fi

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

  # Run db commands on leader only
  if [ -f "$LEADER_FNAME" ]; then
    if psql -U $DBUSER -h $DBHOST -lqt | cut -d \| -f 1 | grep -qw $DBNAME; then
      # database exists
      # $? is 0
      info "DB Already exists, running migration"
      bundle exec rake db:migrate

      info "Creating sandbox gateways"
      nohup bundle exec rake data:create_sandbox_gateways &
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
  fi

  info "Running web"
  cmd="/app/bin/unicorn -c /app/config/unicorn.rb -E ${RAILS_ENV}"

  # Setup log redirection
  ln -sf /dev/stdout "/app/log/${RAILS_ENV}.log"

fi

info "Executing: bundle exec $cmd"
exec bundle exec "$cmd"
