FROM node:14.11.0-alpine3.12

RUN \
    # Update repository indexes from all remote repositories
    apk update \
    # Install packages
    && apk add --no-cache \
        bash='5.0.17-r0' \
        build-base='0.5-r2'
    && rm -rf '/var/cache/apk/*'

ARG PROJECT_ROOT='/var/project'

WORKDIR $PROJECT_ROOT

COPY package.json $PROJECT_ROOT
COPY package-lock.json $PROJECT_ROOT

RUN npm install
