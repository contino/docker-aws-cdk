FROM alpine:3.10

ENV AWS_CDK_VERSION=1.94.1

RUN apk -v --no-cache --update add \
        nodejs \
        npm \
        python3 \
        ca-certificates \
        groff \
        less \
        bash \
        make \
        curl \
        wget \
        zip \
        && \
    update-ca-certificates && \
    npm install -g aws-cdk@${AWS_CDK_VERSION}

VOLUME [ "/root/.aws" ]
VOLUME [ "/opt/app" ]

# Allow for caching python modules
VOLUME ["/usr/lib/python3.7/site-packages/"]

WORKDIR /opt/app

CMD ["cdk", "--version"]
