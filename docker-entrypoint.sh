#!/bin/sh

# If CMD starts with an option, prepend exim
if [ "${1#-}" != "$1" ]; then
	set -- exim "$@"
fi

# Make exim become pid 1 and switch to exim user
if [ "$1" = 'exim' ] && [ "$(id -u)" = '0' ]; then
  exec su-exec exim "$0" "$@"
fi

exec "$@"
