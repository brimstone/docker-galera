.PHONY: docker test

docker:
	docker build -t galera .

test:
	for f in tests/*; do "${f}"; done
