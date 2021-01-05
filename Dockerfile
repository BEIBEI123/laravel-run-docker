FROM php:alpine
LABEL maintainer="yangweicai <yangweicai.123@163.com>"

# 更新系统版本
RUN apk update && apk upgrade

# Install basic dependencies
RUN apk -u add git

# Install PHP extensions
ADD install-php.sh /usr/sbin/install-php.sh
ENV XDEBUG_VERSION 2.9.8
RUN /usr/sbin/install-php.sh

RUN mkdir -p /etc/ssl/certs && update-ca-certificates

WORKDIR /var/www
CMD ["/usr/local/bin/php"]
