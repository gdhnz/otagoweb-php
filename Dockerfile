FROM centos:latest

# Install REMI php yum repos
RUN VERSION=`cat /etc/redhat-release | awk '{printf "%d", $4}'` && \
    yum -q -y install deltarpm wget && \
    wget -q -P /tmp https://dl.fedoraproject.org/pub/epel/epel-release-latest-$VERSION.noarch.rpm && \
    wget -q -P /tmp http://rpms.remirepo.net/enterprise/remi-release-$VERSION.rpm && \
    rpm -U --quiet /tmp/epel-release-latest-$VERSION.noarch.rpm /tmp/remi-release-$VERSION.rpm && \
    rm /tmp/epel-release-latest-$VERSION.noarch.rpm /tmp/remi-release-$VERSION.rpm && \
    /usr/bin/yum-config-manager --enable remi-php70 && \
    yum check-update && yum -q -y update

# Install apache and php
RUN yum -q -y install httpd \
    php \
    php-bcmath \
    php-gd \
    php-intl \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache \
    php-pdo \
    php-pear \
    php-pecl-geoip \
    php-pecl-libsodium \
    php-pecl-xdebug \
    php-pspell \
    php-recode \
    php-snmp \
    php-soap \
    php-tidy \
    php-xml \
    php-xmlrpc \
    php-pecl-zip \
    GeoIP-update

# Update Servername to localhost
RUN sed -i "s/#ServerName.*/ServerName localhost/g" /etc/httpd/conf/httpd.conf

# Add apache config to image
COPY web.conf /etc/httpd/conf.d/

WORKDIR /var/www/html
EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]