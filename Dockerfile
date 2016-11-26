# Exim based SMTP image for production

# FIXME: When the exim package enters the stable release, update this!
FROM alpine:edge
MAINTAINER Max Milton <max@wearegenki.com>

# FIXME: Once the exim package is out of testing, update this!
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache --virtual .smtp-rundeps \
		exim \
	&& mkdir -p /var/log/exim /usr/lib/exim /var/spool/exim \
	\
	# Forward logs to docker log collector
	&& ln -sf /dev/stdout /var/log/exim/main \
	&& ln -sf /dev/stderr /var/log/exim/panic \
	&& ln -sf /dev/stderr /var/log/exim/reject \
	\
	# Unset SUID on all executables
	&& for i in $(find / -perm +6000 -type f); do chmod a-s $i; done

EXPOSE 25

CMD ["exim", "-bd", "-q15m"]
