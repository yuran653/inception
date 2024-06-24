FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-json \
    php82-mysqli \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-intl \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-apcu \
    php82-opcache \
    php82-redis \
	php82-phar \
	php82-gd \
    wget && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
        /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
        /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
        /etc/php82/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

RUN apk info | grep php && php -v && which php

RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.10.0/wp-cli-2.10.0.phar && \
    php wp-cli-2.10.0.phar --info && \
    chmod +x wp-cli-2.10.0.phar && \
    mv wp-cli-2.10.0.phar /usr/local/bin/wp

RUN wp core download --allow-root --version='6.5' --path='/var/www/' && \
    wp core version --allow-root --path='/var/www/' && \
    chmod -R 0777 /var/www/wp-content

COPY ./requirements/wordpress/tools/wp-config.sh /var/www/

RUN chmod +x ./var/www/wp-config.sh

ENTRYPOINT ["/var/www/wp-config.sh"]

CMD ["php-fpm82 -F"]
