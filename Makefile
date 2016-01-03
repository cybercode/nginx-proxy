.PHONY: build

GOVERSION=`go version | sed -E 's/^.+go([0-9\.]+).*/\1/'`

define GOBUILD
(apt-get update && apt-get install -yy musl-dev musl-tools) 1>&2\n\
go get github.com/ddollar/forego && \
cd /go/src/github.com/ddollar/forego && \
CC=musl-gcc go build  --ldflags '-linkmode external -extldflags "-static -s"' && \
cat forego
endef

build: forego
	docker build -t cybercode/nginx-proxy .

forego:
	echo "$(GOBUILD)" | docker run -i --rm golang:$(GOVERSION) > forego
	chmod +x forego

clean:
	rm forego
	docker rmi cybercode/nginx-proxy
