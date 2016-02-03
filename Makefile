

IMAGE ?= galera

SHELL=/bin/sh -e


.PHONY: all docker latest clean test

all: docker clean

docker: version=$(shell docker run --rm -it --entrypoint=/bin/bash ${IMAGE} -c "dpkg -l | awk '\$$2==\"galera-3\" {g=\$$3} \$$2==\"mysql-wsrep-server-5.6\" {m=\$$3} END {print m \"_\" g }'")_$(shell git describe --always --dirty --tags)
docker: latest
	docker tag "${IMAGE}" "${IMAGE}:${version}"

latest:
	docker build -t "${IMAGE}" .

clean:
	docker rmi "${IMAGE}":latest

test:
	@prove
