FROM lscr.io/linuxserver/baseimage-ubuntu:bionic

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
	lighttpd \
	nut-cgi && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

# make backup of nut hosts file, so we can rebuild it each startup
RUN mv /etc/nut/hosts.conf /etc/nut/hosts.conf.original

COPY entrypoint.sh /
RUN  chmod +x /entrypoint.sh;

EXPOSE 80
ENV NUT_HOSTS "MONITOR myups@myserver 'The UPS'"

RUN rm -f /etc/lighttpd/conf-enabled/*-unconfigured.conf && \
    ln -s /etc/lighttpd/conf-available/*-accesslog.conf /etc/lighttpd/conf-enabled/ && \
    ln -s /etc/lighttpd/conf-available/*-cgi.conf /etc/lighttpd/conf-enabled/

RUN sed -i 's|/cgi-bin/|/|g' /etc/lighttpd/conf-enabled/*-cgi.conf && \
    sed -i 's|^\(server.document-root.*=\).*|\1 "/usr/lib/cgi-bin/nut"|g' /etc/lighttpd/lighttpd.conf && \
    sed -i 's|^\(index-file.names.*=\).*|\1 ( "upsstats.cgi" )|g' /etc/lighttpd/lighttpd.conf && \
    sed -i '/alias.url/d' /etc/lighttpd/conf-enabled/*-cgi.conf

ENTRYPOINT ["/entrypoint.sh"]

# set build date
RUN date >/build-date.txt
