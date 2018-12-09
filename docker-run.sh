#!/usr/bin/env bash
set -e

if [ -f /app/tmp/pids/unicorn.pid ]; then
  rm /app/tmp/pids/unicorn.pid
fi

if [ -f /app/tmp/unicorn.pid ]; then
  rm /app/tmp/unicorn.pid
fi

# if [ -f /app/tmp/unicorn.sock ]; then
#   rm /app/tmp/unicorn.sock
# fi

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

# Copy over the production unicorn config if not already so
if [ -f /app/config/unicorn_production.rb ]; then
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

# Test for redis
# if [ -z "${REDIS_IP}" ]; then
#   (printf "PING\r\n"; sleep 1) | nc $REDIS_IP 6379
# fi

#  Now run
bundle exec rake cache:clear

exec bundle exec "$@" -E $RAILS_ENV
