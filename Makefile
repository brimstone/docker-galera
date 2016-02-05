IMAGE ?= galera

SHELL=/bin/sh -e


.PHONY: all docker latest clean test

all: docker clean

docker: version=$(shell git describe --always --dirty --tags)
docker: minorversion=$(shell git describe --always --dirty --tags | sed 's/\.[^.]*$$//')
docker:
	docker build -t "${IMAGE}:${version}" .
	docker tag "${IMAGE}:${version}" "${IMAGE}:${minorversion}"

docker-push:
	@docker login -e="${DOCKER_EMAIL}" -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
	docker push "${IMAGE}"

clean:
	docker rmi "${IMAGE}":latest

test:
	@prove -j9
