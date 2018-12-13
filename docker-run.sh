#!/usr/bin/env bash
set -e

# TODO:Cleanup, move things to functions

function kill_pid() {
  echo "Attempting to kill for PID: $1"
  if [ -f $1 ]; then
    kill $(cat $1)
    echo "Deleting: $1"
    rm $1
  fi
}

function mv_if_exists() {
  echo "mv_if_exists: $1 $2"

  if [ -f $1 ]; then
    if [ -f $2 ]; then
      echo "Both found, removing old: $1 $2"
      rm $2
    fi

    echo "Moving $1 to $2"
    mv $1 $2
  fi
}

# Clear out and creater required folders
if [ ! -d "/app/tmp" ]; then
  mkdir /app/tmp
fi

if [ ! -d "/app/tmp/pids" ]; then
  mkdir /app/tmp/pids
fi

if [ ! -d "/app/tmp/logs" ]; then
  mkdir /app/tmp/logs
else
  rm -rf /app/tmp/logs/*
fi

if [ ! -d "/app/logs" ]; then
  mkdir /app/logs
else
  rm -rf /app/logs/*
fi

# Test for redis
# if [ -z "${REDIS_IP}" ]; then
#   (printf "PING\r\n"; sleep 1) | nc $REDIS_IP 6379
# fi

cmd=""

if [ "${RAILS_TYPE}" == "worker" ]; then
  kill_pid /app/tmp/pids/sidekiq.pid

  mv_if_exists /app/config/sidekiq_production.yml /app/config/sidekiq.yml

  echo "Running sidekiq"
  cmd="/app/bin/sidekiq -C /app/config/sidekiq.yml -e ${RAILS_ENV}"

else

  kill_pid /app/tmp/pids/unicorn.pid
  kill_pid /app/tmp/unicorn.pid
  kill_pid /app/tmp/pids/server.pid

  # Copy over the production unicorn config if not already so
  if  [ "$RAILS_ENV" != "development" ]; then
    mv_if_exists /app/config/unicorn_production.rb /app/config/unicorn.rb
  fi

  # Copy over the production database config if not already so
  mv_if_exists /app/config/database_production.yml /app/config/database.yml

  export PGPASSWORD=$DBPASSWORD

  # Run db commands
  if psql -U $DBUSER -h $DBHOST -lqt | cut -d \| -f 1 | grep -qw $DBNAME; then
      # database exists
      # $? is 0
    bundle exec rake db:migrate
  else
      # ruh-roh
      # $? is 1
    bundle exec rake db:create db:schema:load db:migrate --trace

    #  Clear cache
    bundle exec rake cache:clear
  fi

  echo "Running web"
  cmd="/app/bin/unicorn -c /app/config/unicorn.rb -E ${RAILS_ENV}"

fi

exec bundle exec "$cmd"
