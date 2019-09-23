AWS_CDK_VERSION = 1.9.0
IMAGE_NAME ?= contino/aws-cdk:$(AWS_CDK_VERSION)
TAG = $(AWS_CDK_VERSION)

build:
	docker build -t $(IMAGE_NAME) .

test:
	docker run --rm -it $(IMAGE_NAME) cdk --version

shell:
	docker run --rm -it -v ~/.aws:/root/.aws -v $(shell pwd):/opt/app $(IMAGE_NAME) bash

gitTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
