#!/usr/bin/env bash

bundle exec rake db:migrate

if [[ $? != 0 ]]; then
  echo
  echo "== Failed to migrate. Running setup first."
  echo
  bundle exec rake db:create && \
  bundle exec rake db:migrate
fi
rm -rf tmp/pids/server.pid
bundle exec rake db:seed
#bundle exec bin/delayed_job -n3 start
bundle exec rails s -b 0.0.0.0 -p "${PORT:-3000}"

