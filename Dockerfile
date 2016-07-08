FROM cybercode/alpine-nginx
MAINTAINER Rick Frankel rick (at) cybercode.nyc

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# The official release of forego is dynamically linked and doesn't work with musl
# Install locally build alpine version
# COPY forego /usr/local/bin/

# forego fails w/ /bin/sh. install /bin/bash
# RUN apk --update add bash

ENV GEN_VERSION 0.7.3

# busybox wget doesn't support ssl...
RUN apk --update add curl && \
    curl -L https://github.com/jwilder/docker-gen/releases/download/$GEN_VERSION/docker-gen-alpine-linux-amd64-$GEN_VERSION.tar.gz \
    |  tar -C /usr/local/bin -xvzf - \
    && chown root:root /usr/local/bin/docker-gen \
    && apk del curl && rm /var/cache/apk/*

WORKDIR /app/
ADD app /app

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["nginx"]
