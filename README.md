This is a CentOS 7 image that includes apache, php, composer, and the blackfire php probe. In order to use this image effectively, you'll need to mount:

* /var/www/html/public for your site content (e.g. using "-v /home/user/site:/var/www/html/public")

### Optional mounts
* /etc/php.d for additional .ini files for php
* /var/www/php is also available as a php includes directory

## Example
```bash
$ docker run -p 8080:80 -v /home/user/mysite:/var/www/html/public -d otagoweb/centos
```

## Blackfire
To connect to the blackfire agent, you'll need to run the [blackfire/blackfire](https://hub.docker.com/r/blackfire/blackfire/) image. For more information, visit https://blackfire.io/docs/integrations/docker.

## Installed php packages
### PHP Modules
* bcmath
* blackfire
* bz2
* calendar
* Core
* ctype
* curl
* date
* dom
* exif
* fileinfo
* filter
* ftp
* gd
* geoip
* gettext
* hash
* iconv
* igbinary
* intl
* json
* ldap
* libsodium
* libxml
* mbstring
* mcrypt
* mysqli
* mysqlnd
* openssl
* pcntl
* pcre
* PDO
* pdo_mysql
* pdo_sqlite
* Phar
* posix
* pspell
* readline
* recode
* redis
* Reflection
* session
* shmop
* SimpleXML
* snmp
* soap
* sockets
* SPL
* sqlite3
* standard
* sysvmsg
* sysvsem
* sysvshm
* tidy
* tokenizer
* wddx
* xdebug
* xml
* xmlreader
* xmlrpc
* xmlwriter
* xsl
* Zend OPcache
* zip
* zlib

### Zend Modules
* Xdebug
* Zend OPcache
* blackfire