# Docker-nut-cgi
Docker running nut-cgi.

## References
https://networkupstools.org

## Build
    docker build --pull --no-cache -t danchal/nut-cgi:latest .

## Push
    docker push danchal/nut-cgi:latest

## Run
    $ docker run -d \
        --name nut-cgi \
        -p 8086:80 \
        -e NUT_HOSTS='MONITOR myups@myserver "The UPS"' \
        danchal/nut-cgi
