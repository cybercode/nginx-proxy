.PHONY: build
build:
	docker build -t cybercode/nginx-proxy .

clean:
	docker rmi cybercode/nginx-proxy
