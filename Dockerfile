FROM namshi/smtp
MAINTAINER Max Milton <max@wearegenki.com>

# Harden image by unsetting SUID on all executables
RUN for i in `find / -perm +6000 -type f`; do chmod a-s $i; done

