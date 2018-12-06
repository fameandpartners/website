#!/usr/bin/env bash
set -e

if [ -f /app/tmp/pids/unicorn.pid ]; then
    rm /app/tmp/pids/unicorn.pid
fi

if [ -z "${DATABASE_URL}" ]; then
	echo 'Found a database url, re-write database.yml'

	if [ -f /app/config/database.yml ]; then
		rm /app/config/database.yml
	fi

	echo "$RAILS_ENV:
		adapter: postgresql
		database: $DBNAME
		username: $DBUSER
		password: $DBPASSWORD
		host: $DBHOST" > /app/config/database.yml
fi

# Run db commands
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:create db:schema:load db:migrate --trace

exec bundle exec "$@"

