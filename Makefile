DOCKER_REGISTRY = index.docker.io
IMAGE_NAME = litecoin
IMAGE_VERSION = 0.18.1
IMAGE_ORG = flaccid
IMAGE_TAG = $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

WORKING_DIR := $(shell pwd)

.DEFAULT_GOAL := build

.PHONY: build push

docker-release:: docker-build docker-push ## Builds and pushes the docker image to the registry

docker-push:: ## Pushes the docker image to the registry
		@docker push $(IMAGE_TAG)

docker-build:: ## Builds the docker image locally
		@echo http_proxy=$(HTTP_PROXY) http_proxy=$(HTTPS_PROXY)
		@docker build --pull \
		--build-arg=http_proxy=$(HTTP_PROXY) \
		--build-arg=https_proxy=$(HTTPS_PROXY) \
		-t $(IMAGE_TAG) $(WORKING_DIR)

docker-run:: ## runs the docker image locally
		@docker run -it $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

docker-run-shell:: ## runs the docker image locally, but with a shell
		@docker run -it $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION) /bin/sh

helm-install:: ## installs the application using the local helm chart
		@helm install \
		--namespace crypto \
		-f helm-values.local.yaml \
		litecoin charts/litecoin

helm-uninstall:: ## uninstalls the helm chart
		@helm uninstall \
		--namespace crypto \
		litecoin

helm-validate:: ## dry run/print out the helm chart
		@helm install \
		--dry-run \
		--debug \
		-f helm-values.local.yaml \
			litecoin charts/litecoin

# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## This help target
	@cat .banner
	@echo
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
