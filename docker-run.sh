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

# Run db commands
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:create db:schema:load db:migrate --trace

exec bundle exec "$@"
