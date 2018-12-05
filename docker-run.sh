#!/usr/bin/env bash
set -e

if [ -f /app/tmp/pids/unicorn.pid ]; then
    rm /app/tmp/pids/unicorn.pid
fi

# Run db commands
bundle exec rake db:create db:schema:load db:migrate --trace

exec bundle exec "$@"

