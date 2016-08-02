FROM alpine:latest

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add apache2 ca-certificates \
        php5-apache2 \
        php5-bcmath \
        php5-bz2 \
        php5-calendar \
        php5-cli \
        php5-ctype \
        php5-curl \
        php5-doc \
        php5-dom \
        php5-exif \
        php5-ftp \
        php5-gd \
        php5-geoip@testing \
        php5-gettext \
        php5-gmp \
        php5-iconv \
        php5-intl \
        php5-json \
        php5-ldap \
        php5-mcrypt \
        php5-mysqli \
        php5-opcache \
        php5-openssl \
        php5-pcntl \
        php5-pdo \
        php5-pdo_mysql \
        php5-pdo_sqlite \
        php5-phar \
        php5-posix \
        php5-redis@testing \
        php5-shmop \
        php5-soap \
        php5-soap \
        php5-sockets \
        php5-sysvmsg \
        php5-sysvsem \
        php5-sysvshm \
        php5-wddx \
        php5-xdebug@testing \
        php5-xml \
        php5-xmlreader \
        php5-xmlrpc \
        php5-xsl \
        php5-zip \
        php5-zlib


RUN apk add -u musl \
    && rm -rf /var/cache/apk/*

ADD files/geolitecity /etc/periodic/monthly/
RUN chmod +x /etc/periodic/monthly/geolitecity \
    && run-parts /etc/periodic/monthly

RUN mkdir -p /app/htdocs/public && chown -R apache:apache /app/htdocs \
    && mkdir -p /run/apache2 \
    && sed -i "s/#ServerName.*/ServerName localhost/g" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule rewrite_module/LoadModule rewrite_module/g" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule remoteip_module/LoadModule remoteip_module/g" /etc/apache2/httpd.conf \
    && echo -e "\nTLS_REQCERT\tnever" >> /etc/openldap/ldap.conf

ADD files/apache.conf /etc/apache2/conf.d/

ADD files/run.sh /scripts/run.sh
RUN mkdir -p /scripts/pre-exec.d && \
    mkdir -p /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 80
WORKDIR /app

CMD ["/scripts/run.sh"]
