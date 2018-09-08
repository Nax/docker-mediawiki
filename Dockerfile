FROM php:7.2.9-fpm-alpine

RUN apk add --no-cache --update \
    supervisor \
    nginx \
    && mkdir /src      \
    && cd /src      \
    && curl 'https://releases.wikimedia.org/mediawiki/1.31/mediawiki-1.31.0.tar.gz' -o /src/mediawiki.tar.gz    \
    && mkdir /w \
    && tar xzf /src/mediawiki.tar.gz --strip-components=1 -C /w    \
    && cd /w \
    && rm -rf /src \
    && chown -R www-data:www-data /w \
    && mkdir -p /run/php-fpm/ \
    && chown www-data:www-data /run/php-fpm

COPY supervisord.conf /etc/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint /usr/local/sbin/
COPY php-fpm.conf /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /w
ENTRYPOINT ["/usr/local/sbin/entrypoint"]
