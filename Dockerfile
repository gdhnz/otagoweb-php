FROM centos:latest

# Install REMI php yum repos
RUN VERSION=`cat /etc/redhat-release | awk '{printf "%d", $4}'` \
    && yum -q -y install deltarpm wget \
    && wget -q -P /tmp https://dl.fedoraproject.org/pub/epel/epel-release-latest-$VERSION.noarch.rpm \
    && wget -q -P /tmp http://rpms.remirepo.net/enterprise/remi-release-$VERSION.rpm \
    && rpm -U --quiet /tmp/epel-release-latest-$VERSION.noarch.rpm /tmp/remi-release-$VERSION.rpm \
    && rm -f /tmp/epel-release-latest-$VERSION.noarch.rpm /tmp/remi-release-$VERSION.rpm \
    && /usr/bin/yum-config-manager --enable remi-php70 \
    && yum -q -y install supervisor yum-cron \
    && yum clean all \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /var/lock/subsys \
    && touch /var/lock/subsys/yum-cron \
    && sed -i "s/apply_updates = no/apply_updates = yes/g" /etc/yum/yum-cron.conf \
    && sed -i "s/apply_updates = no/apply_updates = yes/g" /etc/yum/yum-cron-hourly.conf \
    && sed -i "s/download_updates = no/download_updates = yes/g" /etc/yum/yum-cron-hourly.conf \
    && sed -i "s/update_messages = no/update_messages = yes/g" /etc/yum/yum-cron-hourly.conf

# Update and install apache and php
RUN yum -q -y update \
    && yum -q -y install httpd \
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
        php-pecl-geoip \
        php-pecl-libsodium \
        php-pecl-redis \
        php-pecl-xdebug \
        php-pecl-zip \
        php-pspell \
        php-recode \
        php-snmp \
        php-soap \
        php-tidy \
        php-xml \
        php-xmlrpc \
        GeoIP-update \
        composer \
    && echo -e "\n\nalias comp='php -n /usr/bin/composer'" >> ~/.bashrc \
    && yum clean all

# Update Servername to localhost
RUN sed -i "s/#ServerName.*/ServerName localhost/g" /etc/httpd/conf/httpd.conf \
    && sed -i "s/DocumentRoot/#DocumentRoot/g" /etc/httpd/conf/httpd.conf \
    && mkdir -p /var/www/html/public

# Add GeoLite City database to image
COPY files/geolitecityupdate.sh /etc/cron.weekly/geolitecityupdate
RUN chmod +x /etc/cron.weekly/geolitecityupdate \
    && /etc/cron.weekly/geolitecityupdate

# Add apache config to image
COPY files/apache.conf /etc/httpd/conf.d/

# Add supervisord config to image
COPY files/supervisord.ini /etc/supervisord.d/default.ini
RUN chmod 600 /etc/supervisord.d/*.ini

WORKDIR /var/www/html
EXPOSE 80 443
CMD ["/bin/supervisord", "-c", "/etc/supervisord.conf"]
