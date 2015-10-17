all: image tag
.PHONY: all

help:
	@echo 'Goals:'
	@echo '  image - build a docker image'
	@echo '  tag   - tag the latest image with a version based on its contents'
	@echo '  push  - push a docker image to the locally configured docker repository'
.PHONY: help

ORG=mesosphere
REPO=$(shell git rev-parse --show-toplevel | xargs basename)

push:
	docker push $(TAG)
.PHONY: push

image:
	docker build -t $(ORG)/$(REPO):latest .
.PHONY: image

tag:
	docker tag $(ORG)/$(REPO):latest $(ORG)/$(REPO):$(shell ./image-version.sh "$(ORG)/$(REPO):latest")
.PHONY: tag