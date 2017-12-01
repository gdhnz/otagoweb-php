FROM centos:latest

# Install REMI php yum repos and update
RUN VERSION=`cat /etc/redhat-release | awk '{printf "%d", $4}'` \
    && yum makecache fast && yum -q -y install deltarpm wget pygpgme \
    && wget -q -P /tmp https://dl.fedoraproject.org/pub/epel/epel-release-latest-$VERSION.noarch.rpm \
    && wget -q -P /tmp http://rpms.remirepo.net/enterprise/remi-release-$VERSION.rpm \
    && rpm -U --quiet /tmp/epel-release-latest-$VERSION.noarch.rpm /tmp/remi-release-$VERSION.rpm \
    && rm -f /tmp/epel-release-latest-$VERSION.noarch.rpm /tmp/remi-release-$VERSION.rpm \
    && /usr/bin/yum-config-manager --enable remi-php70 \
    && yum -q -y install supervisor yum-cron \
    && /usr/bin/localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /var/lock/subsys \
    && touch /var/lock/subsys/yum-cron \
    && sed -i "s/apply_updates = no/apply_updates = yes/g" /etc/yum/yum-cron.conf \
    && sed -i "s/apply_updates = no/apply_updates = yes/g" /etc/yum/yum-cron-hourly.conf \
    && sed -i "s/download_updates = no/download_updates = yes/g" /etc/yum/yum-cron-hourly.conf \
    && sed -i "s/update_messages = no/update_messages = yes/g" /etc/yum/yum-cron-hourly.conf \
    && yum -q -y update \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install apache and php
RUN yum -q -y install httpd \
        php \
        php-bcmath \
        php-gd \
        php-intl \
        php-json \
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
        git \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && echo -e '\n\nfunction composer() { COMPOSER="/usr/bin/composer" || { echo "Could not find composer in path" >&2 ; return 1 ; } && sed -i "s/zend/;zend/g" /etc/php.d/15-xdebug.ini ; $COMPOSER "$@" ; STATUS=$? ; sed -i "s/;zend/zend/g" /etc/php.d/15-xdebug.ini ; return $STATUS ; }' >> ~/.bashrc \
    && mkdir -p /var/www/php \
    && sed -i "s/include-path/include-path\ninclude_path = '.:\/var\/www\/php:\/usr\/share\/php'/g" /etc/php.ini \
    && sed -i "s/zend_extension/;zend_extension/g" /etc/php.d/15-xdebug.ini \
    && ln -s /proc/1/fd/1 /var/log/httpd/access_log \
    && ln -s /proc/1/fd/2 /var/log/httpd/error_log \
    && /etc/cron.weekly/geoipupdate \
    && ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

# Install blackfire php probe
RUN wget -O - "http://packages.blackfire.io/fedora/blackfire.repo" | tee /etc/yum.repos.d/blackfire.repo \
    && sed -i "s/repo_gpgcheck=1/repo_gpgcheck=0/g" /etc/yum.repos.d/blackfire.repo \
    && yum -q -y install blackfire-php \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && sed -i "s/blackfire\.agent_socket\s=.*/blackfire\.agent_socket=tcp:\/\/blackfire:8707/g" /etc/php.d/zz-blackfire.ini

# Update Servername to localhost
RUN sed -i "s/#ServerName.*/ServerName localhost/g" /etc/httpd/conf/httpd.conf \
    && sed -i "s/DocumentRoot/#DocumentRoot/g" /etc/httpd/conf/httpd.conf \
    && mkdir -p /var/www/html/public

# Add apache config to image
COPY files/apache.conf /etc/httpd/conf.d/

# Add supervisord config to image
COPY files/supervisord.ini /etc/supervisord.d/default.ini
RUN chmod 600 /etc/supervisord.d/*.ini

WORKDIR /var/www/html
EXPOSE 80 443
CMD ["/bin/supervisord", "-c", "/etc/supervisord.conf"]
