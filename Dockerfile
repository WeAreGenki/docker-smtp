# Exim based smtp image for production

# TODO: Logging

# FIXME: When the exim package enter the stable release, update this!
FROM alpine:edge
MAINTAINER Max Milton <max@wearegenki.com>

# FIXME: Once the exim package is out of testing, update this!
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache --virtual .smtp-rundeps \
		exim \
	# Unset SUID on all executables
	&& for i in $(find / -perm +6000 -type f); do chmod a-s $i; done

EXPOSE 25

CMD ["exim", "-bd", "-q15m"]
