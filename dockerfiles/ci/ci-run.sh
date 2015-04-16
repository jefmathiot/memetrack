#!/bin/bash
set -e

RAKE='bundle exec rake'
CURRENT_DIRECTORY=`pwd`

wait_for_webapp() {
  attempts=1
  until $(curl --output /dev/null --silent --head --fail $http_probe)
  do
    echo -ne "Waiting for server, attempt $attempts/$1\r"
    attempts=$((attempts+1))
    sleep 1
    if [[ $attempts -gt $1 ]]
    then
      echo -ne "\n"
      echo "Failed to contact web server after $1 attempts"
      exit 1
    fi
  done
}

memetrack_cleanup() {
  docker-compose stop || echo 'No containers were running'
  docker-compose rm --force || echo 'Nothing to cleanup'
  rm -f tmp/pids/server.pid
}

memetrack_startup() {
  export RAILS_ENV=$1
  export SECRET_KEY_BASE=$(ruby -r 'securerandom' -e "puts SecureRandom.hex(64)")
  memetrack_cleanup
  docker-compose up -d
  http_probe="http://$(docker-compose port web 80)"
}

memetrack_run() {
  echo "Running $1 in $(pwd)"
  docker-compose run app bash -c "bundle exec $1"
}

memetrack_rake() {
  memetrack_run "rake $1"
}

rm -rf log/*

case "$1" in
  'unit-test')
    memetrack_startup 'test'
    memetrack_rake 'db:create test'
    ;;
  'end-to-end')
    memetrack_startup 'production'
    memetrack_rake 'db:setup assets:precompile'
    wait_for_webapp 30
    cd integration
    # Running "outside" Docker (we hit the nested Web container)
    bundle exec cucumber
    cd $CURRENT_DIRECTORY
    memetrack_rake 'assets:clean'
    ;;
  'static-analysis')
    memetrack_startup
    memetrack_run 'rubocop -f html > tmp/static-analysis.html'
    ;;
  *)
    echo "Usage : $0 <unit-test|end-to-end|static-analysis>"
    ;;
esac

memetrack_cleanup
