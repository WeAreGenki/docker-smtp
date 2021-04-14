# Exim based SMTP image for production

# FIXME: When the exim package enters the stable release, update this!
FROM alpine:edge@sha256:fa3bd1cb8b0d2d6a4de1ea7e52dffee36896bc2b1566e9a89c16637051467225
LABEL MAINTAINER="Max Milton <max@wearegenki.com>"

# FIXME: Once the exim package is out of testing, update this!
RUN set -xe \
	&& addgroup -g 3013 -S exim \
	&& adduser -D -u 3013 -S -h /var/spool/exim -s /sbin/nologin -G exim exim \
	&& mkdir -p /var/log/exim /usr/lib/exim /var/spool/exim \
	&& echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache exim \
	&& ln -sf /dev/stdout /var/log/exim/main \
	&& ln -sf /dev/stderr /var/log/exim/panic \
	&& ln -sf /dev/stderr /var/log/exim/reject \
	&& chown -R exim /var/log/exim /usr/lib/exim /var/spool/exim \
	\
	# Unset SUID on all files
	&& for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

COPY exim.conf /etc/exim/exim.conf

USER exim
EXPOSE 2525

CMD ["exim", "-bdf", "-q15m"]
