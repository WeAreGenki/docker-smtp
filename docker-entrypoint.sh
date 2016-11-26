#!/bin/sh

# If CMD starts with an option, prepend exim
if [ "${1#-}" != "$1" ]; then
	set -- exim "$@"
fi

# Make exim become pid 1 and switch to exim user
if [ "$1" = 'exim' ] && [ "$(id -u)" = '0' ]; then
	# chown -R exim: /var/log/exim /usr/lib/exim /var/spool/exim
  # exec su-exec exim "$0" "$@"
	echo "1"
fi

exec "$@"
