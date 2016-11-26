# SMTP Relay Docker Image

[![](https://images.microbadger.com/badges/image/wearegenki/smtp.svg)](https://microbadger.com/images/wearegenki/smtp "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/wearegenki/smtp.svg)](http://microbadger.com/images/wearegenki/smtp "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/wearegenki/smtp.svg)](http://microbadger.com/images/wearegenki/smtp "Get your own commit badge on microbadger.com")

Minimal SMTP relay docker using Exim4 running on an Alpine Linux base. The default configuration is as a smarthost relay — for sending emails from your docker cluster to an email delivery service like Sparkpost, SendGrid, or Amazon Simple Email Service.

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
  -e SMARTHOST_PUBLIC_NAME="LOGIN" \
  -e SMARTHOST_USERNAME="SMTP_Injection" \
  -e SMARTHOST_PASSWORD="your_sparkpost_api_token" \
  wearegenki/smtp:latest
```

**NOTE:** The separating delimiters are different for RELAY_TO_DOMAINS (: colons) and RELAY_FROM_HOSTS (; semicolons). Your username and password are probably your API key.

Port 25 is open to your internal Docker network. If you need to expose this publicly, so it's possible to connect from a different network, add `-p 25:25/tcp` to your docker run command.

## Licence

ISC. See [LICENCE.md](https://github.com/WeAreGenki/docker-smtp/blob/master/LICENCE.md).

## Author

Proudly made by Max Milton &lt;<max@wearegenki.com>&gt;.

&copy; We Are Genki
