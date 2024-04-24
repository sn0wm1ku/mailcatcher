FROM alpine as Build
RUN apk update \
  && apk add --no-cache ruby \
  ruby-json libc6-compat sqlite-libs libstdc++ \
  ruby-dev make g++ sqlite-dev \
  && ( [ "$(uname -m)" != "aarch64" ] || gem install sqlite3 --version="~> 1.3" --platform=ruby ) \
  && gem install mailcatcher --no-document \
  && apk del --rdepends --purge ruby-dev make g++ sqlite-dev \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
EXPOSE 1025 1080
ENV TIMEZONE="JST" \
  MAIL_LIMIT=50
CMD ["sh", "-c", "mailcatcher --foreground --smtp-port=1025 --http-port=1080 --ip=0.0.0.0 --messages-limit=$MAIL_LIMIT"]