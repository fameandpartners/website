#!/usr/bin/env bash
set -e

if [ -f /app/tmp/pids/unicorn.pid ]; then
    rm /app/tmp/pids/unicorn.pid
fi

if [ ! -f /app/config/database.yml ]; then
	echo "Cannot find database.yml"

	if [ -z "${DATABASE_URL}" ]; then

		echo "Cannot find database.yml and database url"

		# no db and no env var
 		echo "$RAILS_ENV:
             adapter: postgresql
             database: $DBNAME
             username: $DBUSER
		 	 password: $DBPASSWORD
             host: $DBHOST
            " > /app/config/database.yml
	else
		echo 'Found a database url'
		exit 1
	fi
fi

# Run db commands
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:create db:schema:load db:migrate --trace

exec bundle exec "$@"

