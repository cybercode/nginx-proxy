FROM cybercode/alpine-nginx
MAINTAINER Rick Frankel rick (at) cybercode.nyc

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# The official release of forego is dynamically linked and doesn't work with musl
# Install locally build alpine version
COPY forego /usr/local/bin/

# forego fails w/ /bin/sh. install /bin/bash
RUN apk --update add bash

ENV DOCKER_GEN_VERSION 0.5.0

RUN wget https://github.com/cybercode/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

WORKDIR /app/
ADD app /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
