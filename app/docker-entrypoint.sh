#!/bin/sh

# Warn if the DOCKER_HOST socket does not exist
if [[ $DOCKER_HOST == unix://* ]]; then
    socket_file=${DOCKER_HOST#unix://}
    if ! [ -S $socket_file ]; then
        cat >&2 <<-EOT
           ERROR: you need to share your Docker host socket with a volume at $socket_file
           Typically you should run your nginx-proxy with: \`-v /var/run/docker.sock:$socket_file:ro\`
           See the documentation at http://git.io/vZaGJ
	EOT
        exit 1
    fi
fi

docker-gen -config /app/docker-gen.cfg
exec "$@"
