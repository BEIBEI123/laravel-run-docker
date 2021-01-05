#!/bin/sh

apk add bzip2 file re2c freetds freetype icu libintl libldap libjpeg libmcrypt libpng libpq libwebp libzip

TMP="autoconf \
    bzip2-dev \
    freetds-dev \
    freetype-dev \
    g++ \
    gcc \
    gettext-dev \
    icu-dev \
    jpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    libzip-dev \
    make \
    openldap-dev \
    postgresql-dev"
apk add $TMP

# Configure extensions
docker-php-ext-configure gd --with-jpeg-dir=usr/ --with-freetype-dir=usr/ --with-webp-dir=usr/
docker-php-ext-configure ldap --with-libdir=lib/
docker-php-ext-configure pdo_dblib --with-libdir=lib/

docker-php-ext-install \
    bcmath \
    bz2 \
    exif \
    gd \
    gettext \
    intl \
    ldap \
    pdo_dblib \
    pdo_mysql \
    pdo_pgsql \
    xmlrpc \
    zip

# Download trusted certs 
mkdir -p /etc/ssl/certs && update-ca-certificates

# Install composer
cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
	mv composer.phar /usr/bin/composer && \
	chmod +x /usr/bin/composer

apk del $TMP

# 安装 PHPUnit
curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit
