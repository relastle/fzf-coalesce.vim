.PHONY: docker
docker:
	docker build -t relastle/coalesce:0.1.0 -f docker/Dockerfile .
