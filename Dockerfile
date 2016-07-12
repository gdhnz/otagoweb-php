FROM php:apache

RUN apt-get update && apt-get install -y \
        apt-utils \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libbz2-dev \
        libicu-dev \
        libldap2-dev \
        libtidy-dev \
        libxslt1-dev \
        icu-doc \
        mcrypt \
        
    && docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif ftp gettext \
        intl mcrypt mysqli opcache pdo_mysql shmop soap sockets \
        sysvmsg tidy wddx xmlrpc xsl zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) gd ldap \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug
