APP_NAME = aws-cdk
DOCKER_REPO = misva
AWS_CDK_VERSION = 1.83.0
IMAGE_NAME ?= $(DOCKER_REPO)/$(APP_NAME):$(AWS_CDK_VERSION)
TAG = $(AWS_CDK_VERSION)

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# all:

# Docker build
build: ## Build docker image
	@echo 'build docker image ${IMAGE_NAME}'
	docker build -t $(IMAGE_NAME) .

# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to DockerHub

publish-latest: tag-latest ## Publish the `latest` tagged container to DockerHub
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to DockerHub
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(AWS_CDK_VERSION)

run: ## Run container on port configured in `config.env`
	@echo 'Run docker container'
	docker run -td --name="$(APP_NAME)" $(IMAGE_NAME) bash

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` and `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(IMAGE_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(IMAGE_NAME) $(DOCKER_REPO)/$(APP_NAME):$(AWS_CDK_VERSION)

test: ## Test container with CDK version ${AWS_CDK_VERSION}
	@echo 'test container with CDK version ${AWS_CDK_VERSION}'
	docker run --rm -it $(IMAGE_NAME) cdk --version
