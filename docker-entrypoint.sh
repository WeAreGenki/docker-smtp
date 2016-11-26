#!/bin/sh

# Make exim become pid 1 and switch to exim user
if [ "$1" = 'exim' ] && [ "$(id -u)" = '0' ]; then
  exec su-exec exim "$0" "$@"
fi

exec "$@"
