`nginx-proxy` sets up a container which invokes [docker-gen][1] on startup, generating a reverse proxy configs for nginx and runs nginx. 

> **Note**: Unlike [`jwilder/ngnix-proxy`](https://github.com/jwilder/nginx-proxy), it does not run `docker-gen` as a service or reload `nginx`

See [Automated Nginx Reverse Proxy for Docker][2] for why you might want to use this.

### Usage

To run it:
1. Start any containers you want proxied with an env var `VIRTUAL_HOST=subdomain.youdomain.com`


        $ docker run -e VIRTUAL_HOST=foo.bar.com  ...

2. Start the proxy

        $ docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy


The containers being proxied must [expose](https://docs.docker.com/reference/run/#expose-incoming-ports) the port to be proxied, either by using the `EXPOSE` directive in their `Dockerfile` or by using the `--expose` flag to `docker run` or `docker create`.

Provided your DNS is setup to forward foo.bar.com to the a host running nginx-proxy, the request will be routed to a container with the VIRTUAL_HOST env var set.

### Multiple Ports

If your container exposes multiple ports, nginx-proxy will default to the service running on port 80.  If you need to specify a different port, you can set a VIRTUAL_PORT env var to select a different one.  If your container only exposes one port and it has a VIRTUAL_HOST env var set, that port will be selected.

  [1]: https://github.com/jwilder/docker-gen
  [2]: http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/

