# SMTP Relay Docker Image

[![](https://images.microbadger.com/badges/image/wearegenki/smtp.svg)](https://microbadger.com/images/wearegenki/smtp "Get your own image badge on microbadger.com") [![GitHub Tag](https://img.shields.io/github/tag/wearegenki/docker-smtp.svg)](https://registry.hub.docker.com/u/wearegenki/smtp/)

Minimal SMTP relay docker image using Exim4 running on an Alpine Linux base. The default configuration is as a smarthost relay — for sending emails from your docker cluster to an email delivery service like Sparkpost, SendGrid, or Amazon Simple Email Service.

Thanks to Alpine Linux the _uncompressed_ image size is a tiny 8 MB (compared to 175 MB using Debian)!

**TIP:** If you need to get emails from your other containers to this one, consider adding [sSMTP](https://wiki.debian.org/sSMTP) to your existing images. This way you don't need to set up anything fancy in your applications, just use Linux's standard way of sending emails via `/usr/sbin/sendmail`.

## Usage

If you're on the command-line you can run:

```
docker run -d \
  --name your-smtp \
  -v /mnt/your-data-dir/smtp:/var/spool/exim:rw \
  -e LOCAL_DOMAINS="@" \
  -e RELAY_TO_DOMAINS="smtp.sparkpostmail.com : email.yourdomain.com" \
  -e RELAY_FROM_HOSTS="192.168.0.0/16 ; *.yourdomain.com" \
  -e SMARTHOST_HOST="smtp.sparkpostmail.com" \
  -e SMARTHOST_PORT="587" \
  -e SMARTHOST_USERNAME="SMTP_Injection" \
  -e SMARTHOST_PASSWORD="your_sparkpost_api_token" \
  wearegenki/smtp:latest
```

#### NOTES:

1. The container listens for incoming connections on port `2525` (high port number so the container doesn't need the `NET_BIND_SERVICE` capability).
2. Port 2525 is open to your internal Docker network. If you need to expose this publicly to connect from a different network add `-p 2525:2525/tcp` to your docker run command.
3. The separating delimiters are different for LOCAL_DOMAINS or RELAY_TO_DOMAINS (`:` colons) and RELAY_FROM_HOSTS (`;` semicolons).

## Licence

ISC. See [LICENCE.md](https://github.com/WeAreGenki/docker-smtp/blob/master/LICENCE.md).

## Author

Proudly made by Max Milton &lt;<max@wearegenki.com>&gt;.

&copy; We Are Genki
