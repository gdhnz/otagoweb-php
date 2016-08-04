#!/bin/sh
set -e

echo "Add multiple php.ini conf directories."
export PHP_INI_SCAN_DIR=/app/php:/etc/php5/conf.d

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

exec httpd -DFOREGROUND