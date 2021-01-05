FROM php:alpine
LABEL maintainer="yangweicai <yangweicai.123@163.com>"

# 更新系统版本
RUN apk update && apk upgrade

# 安装git
RUN apk -u add git

# 安装 PHP 扩展
ADD install-php.sh /usr/sbin/install-php.sh
ENV XDEBUG_VERSION 2.9.8
RUN /usr/sbin/install-php.sh

RUN mkdir -p /etc/ssl/certs && update-ca-certificates

WORKDIR /var/www
CMD ["/usr/local/bin/php"]
