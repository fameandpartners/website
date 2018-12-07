#!/usr/bin/env bash
set -e

if [ -f /app/tmp/pids/unicorn.pid ]; then
    rm /app/tmp/pids/unicorn.pid
fi

if [ -z "${DATABASE_URL}" ]; then
  echo 'Did not find a database url'
else
  echo 'Found a database url'
fi

if [ ! -z "${DBNAME}" ]; then
  echo 're-write database.yml'

  if [ ! -f /app/config/database.yml ]; then
    touch /app/config/database.yml
  else
    rm /app/config/database.yml
    touch /app/config/database.yml
  fi

  # Generate the file
    cat > /app/config/database.yml <<EOL
${RAILS_ENV}:
  adapter: postgresql
  database: ${DBNAME}
  username: ${DBUSER}
  password: ${DBPASSWORD}
  host: ${DBHOST}
EOL
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
exec bundle exec "$@" -e $RAILS_ENV
