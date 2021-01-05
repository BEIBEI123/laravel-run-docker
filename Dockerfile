FROM php:7.4.13-fpm-alpine3.12
LABEL maintainer="yangweicai <yangweicai.123@163.com>"

# 更新系统版本
RUN apk update && apk upgrade

# 安装git
RUN apk -u add git

# 更新libiconv
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php


# 安装 PHP 扩展
RUN apk add bzip2 file re2c freetds freetype icu libintl libldap libjpeg libmcrypt libpng libpq libwebp libzip
RUN apk add autoconf bzip2-dev freetds-dev freetype-dev g++ gcc gettext-dev icu-dev jpeg-dev libmcrypt-dev libpng-dev libwebp-dev libxml2-dev libzip-dev make openldap-dev postgresql-dev

RUN docker-php-ext-configure gd --with-webp=/usr/include/webp --with-jpeg=/usr/include --with-freetype=/usr/include/freetype2
RUN docker-php-ext-configure ldap --with-libdir=lib/
RUN docker-php-ext-configure pdo_dblib --with-libdir=lib/
RUN docker-php-ext-install bcmath bz2 exif gd gettext intl ldap pdo_dblib pdo_mysql pdo_pgsql zip

# 安装 composer
RUN cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
	mv composer.phar /usr/bin/composer && \
	chmod +x /usr/bin/composer

# 安装 PHPUnit
RUN curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit

# Download trusted certs
RUN mkdir -p /etc/ssl/certs && update-ca-certificates

WORKDIR /var/www
CMD ["/usr/local/bin/php"]