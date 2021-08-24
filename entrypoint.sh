#!/bin/sh
echo "Starting nut-cgi, build date $(cat /build-date.txt)"
echo "${NUT_HOSTS}"

# setup list of monitored ups hosts
cp /etc/nut/hosts.conf.original /etc/nut/hosts.conf

IFS=';'
for host in $NUT_HOSTS
do
    echo "${host}" >> /etc/nut/hosts.conf
done

/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
