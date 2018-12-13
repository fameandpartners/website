#!/usr/bin/env bash
set -e

# TODO:Cleanup, move things to functions

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

#  Clear cache
bundle exec rake cache:clear

cmd=""

if [ "${RAILS_TYPE}" == "web"]; then

  if [ -f /app/tmp/pids/unicorn.pid ]; then
    if [ -d /proc/`cat /app/tmp/pids/unicorn.pid` ]; then
      kill -USR1 `cat /app/tmp/pids/unicorn.pid`
    fi
    rm /app/tmp/pids/unicorn.pid
  fi

  if [ -f /app/tmp/unicorn.pid ]; then
    if [ -d /proc/`cat /app/tmp/unicorn.pid` ]; then
      kill -USR1 `cat /app/tmp/unicorn.pid`
    fi
    rm /app/tmp/unicorn.pid
  fi

  if [ -f /app/tmp/pids/server.pid ]; then
    if [ -d /proc/`cat /app/tmp/pids/server.pid` ]; then
      kill -USR1 `cat /app/tmp/pids/server.pid`
    fi
    rm /app/tmp/pids/server.pid
  fi

  # Copy over the production unicorn config if not already so
  if [ -f /app/config/unicorn_production.rb ] && [ "$RAILS_ENV" != "development" ]; then
    if [ -f /app/config/unicorn.rb ]; then
      rm /app/config/unicorn.rb
    fi

    mv /app/config/unicorn_production.rb /app/config/unicorn.rb
  fi

  # Copy over the production database config if not already so
  if [ -f /app/config/database_production.yml ]; then
    if [ -f /app/config/database.yml ]; then
      rm /app/config/database.yml
    fi

    mv /app/config/database_production.yml /app/config/database.yml
  fi

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
  fi
  cmd="/app/bin/unicorn -c /app/config/unicorn.rb -E ${RAILS_ENV}"
else

  if [ -f /app/tmp/pids/sidekiq.pid ]; then
    if [ -d /proc/`cat /app/tmp/pids/sidekiq.pid` ]; then
      kill -USR1 `cat /app/tmp/pids/sidekiq.pid`
    fi
    rm /app/tmp/pids/sidekiq.pid
  fi

  cmd="/app/bin/sidekiq"
fi

exec bundle exec "$cmd"
