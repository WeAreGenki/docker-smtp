# Exim based SMTP image for production

# FIXME: When the exim package enters the stable release, update this!
FROM alpine:edge
MAINTAINER Max Milton <max@wearegenki.com>

ARG VERSION
ARG VCS_REF

LABEL org.label-schema.version=$VERSION \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/WeAreGenki/smtp" \
			org.label-schema.vendor="We Are Genki"

# FIXME: Once the exim package is out of testing, update this!
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache --virtual .smtp-rundeps \
		exim \
	&& mkdir -p /var/log/exim /usr/lib/exim /var/spool/exim \
	&& ln -sf /dev/stdout /var/log/exim/main \
	&& ln -sf /dev/stderr /var/log/exim/panic \
	&& ln -sf /dev/stderr /var/log/exim/reject \
	&& chown -R exim /var/log/exim /usr/lib/exim /var/spool/exim \
	\
	# Unset SUID on all executables
	&& for i in $(find / -perm +6000 -type f); do chmod a-s $i; done

COPY exim.conf /etc/exim/exim.conf

USER exim
EXPOSE 2525

CMD ["exim", "-bdf", "-q15m"]
