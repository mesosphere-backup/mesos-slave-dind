all: image tag
.PHONY: all

help:
	@echo 'Goals:'
	@echo '  image    - build a docker image'
	@echo '  tag      - tag the latest image with a version based on its contents'
	@echo '  push     - push a docker image to the locally configured docker repository'
	@echo '  release  - create release tag from latest version'
.PHONY: help

ORG=mesosphere
REPO=$(shell git rev-parse --show-toplevel | xargs basename)

define image-version
$(shell ./image-version.sh "$(ORG)/$(REPO):latest");
endef

push:
	docker push $(TAG)
.PHONY: push

image:
	docker build -t $(ORG)/$(REPO):latest .
.PHONY: image

tag:
	$(eval VERSION=$(image-version))
	docker tag $(ORG)/$(REPO):latest $(ORG)/$(REPO):$(VERSION)
.PHONY: tag

release:
	$(eval VERSION=$(image-version))
	git tag -a "$(VERSION)" -m '$(REPO) version $(VERSION)'
.PHONY: release
