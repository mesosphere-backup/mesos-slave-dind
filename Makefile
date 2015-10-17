all: help

help:
	@echo 'Targets:'
	@echo '  image - build a docker image'
	@echo '  tag   - tag the latest image with a version based on its contents'
	@echo '  push  - push a docker image to the locally configured docker repository'

ORG=mesosphere
REPO=$(shell git rev-parse --show-toplevel) | xargs basename)

all: image tag

push:
	docker push $(TAG)

image:
	docker build -t $(ORG)/$(REPO):latest .

tag:
	docker tag $(ORG)/$(REPO):latest $(ORG)/$(REPO):$(shell version.sh "$(ORG)/$(REPO):latest")