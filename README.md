This is an Alpine Linux image that includes apache and php. In order to use this image effectively, you'll need to mount:

* /app/htdocs/public for your site content (e.g. using "-v /home/user/site:/app/htdocs/public")

### Optional mounts
* /app/php for additional .ini files for php
* /usr/share/php is also available as a php includes directory

## Example
```bash
$ docker run -p 8080:80 -v /home/user/mysite:/app/htdocs/public -d otagoweb/php
```

## Installed php packages
### PHP Modules
* bcmath
* bz2
* calendar
* Core
* ctype
* curl
* date
* dom
* ereg
* exif
* fileinfo
* filter
* ftp
* gd
* geoip
* gettext
* gmp
* hash
* iconv
* intl
* json
* ldap
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
* readline
* redis
* Reflection
* session
* shmop
* SimpleXML
* soap
* sockets
* SPL
* standard
* sysvmsg
* sysvsem
* sysvshm
* tokenizer
* wddx
* xml
* xmlreader
* xmlrpc
* xmlwriter
* xsl
* Zend OPcache
* zip
* zlib

### Zend Modules
* Zend OPcache
