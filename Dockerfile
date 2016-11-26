# Exim based SMTP image for production

# FIXME: When the exim package enters the stable release, update this!
FROM alpine:edge
MAINTAINER Max Milton <max@wearegenki.com>

# FIXME: Once the exim package is out of testing, update this!
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache --virtual .smtp-rundeps \
		exim \
		su-exec \
	&& apk add --no-cache --virtual .build-deps \
		libcap \
	&& mkdir -p /var/log/exim /usr/lib/exim /var/spool/exim \
	\
	# Forward logs to docker log collector
	&& ln -sf /dev/stdout /var/log/exim/main \
	&& ln -sf /dev/stderr /var/log/exim/panic \
	&& ln -sf /dev/stderr /var/log/exim/reject \
	\
	# && chown -R exim:exim /var/log/exim /usr/lib/exim /var/spool/exim \
	# && chmod 0511 /usr/sbin/exim \
	&& setcap cap_net_bind_service=+ep /usr/sbin/exim \
	&& apk del --purge .build-deps \
	\
	# Unset SUID on all executables
	&& for i in $(find / -perm +6000 -type f); do chmod a-s $i; done

COPY exim.conf /etc/exim/exim.conf

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.version=$VERSION \
			org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/WeAreGenki/smtp" \
			org.label-schema.vendor="We Are Genki"

WORKDIR /var/spool/exim

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 25

CMD ["exim", "-bdf", "-q15m"]
