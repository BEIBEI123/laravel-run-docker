FROM php:7.4.13-fpm-alpine3.12
LABEL maintainer="yangweicai <yangweicai.123@163.com>"

# 更新系统版本
RUN apk update && apk upgrade

# 安装git
RUN apk -u add git

# 安装glibc
RUN apk add --no-cache bash && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
    apk add --no-cache glibc-2.30-r0.apk && \
    rm -rf glibc-2.30-r0.apk

RUN apk add --update --no-cache \
    build-base \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    oniguruma-dev \
    curl \
    autoconf \
    libmcrypt-dev \
    libxml2-dev \
    libsodium \
    gd-dev \
    supervisor \
    openssl \
    php7-openssl \


# extend install
RUN docker-php-ext-install bcmath ctype fileinfo json mysqli pdo pdo_mysql tokenizer xml opcache 
RUN docker-php-ext-configure opcache --enable-opcache 
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ 
RUN docker-php-ext-configure zip 


# 安装 composer
RUN cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
	mv composer.phar /usr/bin/composer && \
	chmod +x /usr/bin/composer

# 安装 PHPUnit
RUN curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit

# Download trusted certs
RUN mkdir -p /etc/ssl/certs && update-ca-certificates

#  Clean
RUN rm -rf /var/cache/apk/* 
RUN docker-php-source delete 
RUN rm -rf /root/.composer/cache

WORKDIR /var/www
CMD ["/usr/local/bin/php"]
