FROM node:14.11.0-alpine3.12

ENV NODE_ENV 'development'

RUN \
    # Update repository indexes from all remote repositories
    apk update \
    # Install packages
    && apk add --no-cache \
        bash='5.0.17-r0' \
        build-base='0.5-r2' \
    && rm -rf '/var/cache/apk/*'

ARG PROJECT_ROOT='/var/project'

WORKDIR $PROJECT_ROOT
