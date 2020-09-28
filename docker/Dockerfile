FROM node:14.11.0-alpine3.12

ENV NODE_ENV 'development'

RUN apk update          \
  && apk add --no-cache \
    bash                \
    bats                \
    build-base          \
    curl                \
    jq                  \
  && rm -rf '/var/cache/apk/*'

ARG YQ_VERSION='3.4.0'
ARG YQ_RELEASE="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64"
ARG YQ_INSTALL_PATH='/usr/local/bin/yq'
RUN curl -fsSL "${YQ_RELEASE}" -o "${YQ_INSTALL_PATH}" && chmod 0755 "${YQ_INSTALL_PATH}"

ARG PROJECT_ROOT='/var/project'
WORKDIR $PROJECT_ROOT
