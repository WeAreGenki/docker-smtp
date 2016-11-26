# Exim based smtp image for production

FROM alpine:3.4
MAINTAINER Max Milton <max@wearegenki.com>

# FIXME: Once the exim package is out of testing, update this!
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --no-cache --virtual .smtp-rundeps \
    exim@testing \
  # TODO: Taken from previous image, do something better
  && find /var/log -type f | while read f; do echo -ne '' > $f; done; \
  \
  # Unset SUID on all executables
  && for i in `find / -perm +6000 -type f`; do chmod a-s $i; done

EXPOSE 25

CMD ["exim", "-bd", "-q15m"]
