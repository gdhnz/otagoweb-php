#!/bin/sh

/usr/bin/curl -s "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" \
    | /usr/bin/gunzip -c > /usr/share/GeoIP/GeoLiteCity.dat