# Docker AWS CDK

Containerised AWS CDK to ensure consistent local development and simple CD pipelines. To use the container refer to DockerHub repo [misva/aws-cdk](https://hub.docker.com/repository/docker/misva/aws-cdk).

## Usage

Run as a command using `cdk` as entrypoint:

    docker run --rm --entrypoint cdk misva/aws-cdk --version

Run as a shell and mount `.aws` folder and current directory as volumes:

    docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/opt/app misva/aws-cdk bash

Using docker-compose:

    cdk:
        image: misva/aws-cdk
        env_file: .env
        entrypoint: aws
        working_dir: /opt/app
        volumes:
        - ~/.aws:/root/.aws
        - .:/opt/app:rw

And run `docker-compose run cdk --version`

## Language Support

CDK Supports different languages to define your (re)usable assets.

### JavaScrip/TypeScript

This should work out of the box through `package.json` and `node_modules`, which
are automatically _cached_ in your working directory.

### Python

This image ships with Python 3 installed. To cache installed cdk python packages,
`site-packages` is exposed as a volume. This allows you to cache packages between
invocations:

    cdk:
        ...
        volumes:
        - cdk-python:/usr/lib/python3.7/site-packages/
        - ...
    volumes:
        cdk-python

Then, if you install e.g. `aws-cdk.core` through pip (`pip3 install aws-cdk.core`)
in a container, you won't have to install it again next time you start a new
container.

## Build

Update the `AWS_CDK_VERSION` in both `Makefile` and `Dockerfile`. The run:

    make build

Docker Hub will automatically trigger a new build.

## Makefile

Refer to Makefile help for provided utilities.

```
$ make
help                           This help.
build                          Build docker image
publish                        Publish the `{version}` ans `latest` tagged containers to DockerHub
publish-latest                 Publish the `latest` tagged container to DockerHub
publish-version                Publish the `{version}` taged container to DockerHub
run                            Run container on port configured in `config.env`
tag                            Generate container tags for the `{version}` and `latest` tags
tag-latest                     Generate container `{version}` tag
tag-version                    Generate container `latest` tag
test                           Test container with CDK version ${AWS_CDK_VERSION}
```

## Acknowledge

* [Contino docker-aws-cdk](https://github.com/contino/docker-aws-cdk) repo for the fork
* [M.Peter Makefile](https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db) snippets for the hints on useful targets
