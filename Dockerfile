FROM lscr.io/linuxserver/baseimage-ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update;
RUN apt-get install --no-install-recommends --yes \
	lighttpd \
	nut-cgi;
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

# make backup of nut hosts file, so we can rebuild it each startup
RUN mv /etc/nut/hosts.conf /etc/nut/hosts.conf.original

COPY entrypoint.sh /
RUN  chmod +x /entrypoint.sh;

EXPOSE 80
ENV NUT_HOSTS "MONITOR myups@myserver 'The UPS'"

RUN rm -f /etc/lighttpd/conf-enabled/*-unconfigured.conf && \
    ln -s /etc/lighttpd/conf-available/*-accesslog.conf /etc/lighttpd/conf-enabled/ && \
    ln -s /etc/lighttpd/conf-available/*-cgi.conf /etc/lighttpd/conf-enabled/

RUN sed -i 's|^\(server.document-root.*=\).*|\1 "/usr/share/nut/www"|g' /etc/lighttpd/lighttpd.conf && \
    sed -i '/alias.url/d' /etc/lighttpd/conf-enabled/*-cgi.conf

RUN ln -s /usr/lib/cgi-bin/ /usr/share/nut/www/ && \
    echo "I_HAVE_SECURED_MY_CGI_DIRECTORY" > /etc/nut/upsset.conf

RUN sed -i 's|BGCOLOR="#FFFFFF"|BGCOLOR="#808080"|g' /etc/nut/upsstats.html

ENTRYPOINT ["/entrypoint.sh"]

# set build date
RUN date >/build-date.txt
