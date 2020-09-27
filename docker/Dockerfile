FROM node:14.11.0-alpine3.12

ENV NODE_ENV 'development'

RUN apk update          \
  && apk add --no-cache \
    bash                \
    bats                \
    build-base          \
    curl                \
  && rm -rf '/var/cache/apk/*'

ARG YQ_VERSION='3.4.0'
ARG YQ_RELEASE="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64"
ARG YQ_INSTALL_PATH='/usr/local/bin/yq'
RUN curl -fsSL "${YQ_RELEASE}" -o "${YQ_INSTALL_PATH}" && chmod 0755 "${YQ_INSTALL_PATH}"

# https://github.com/bats-core/bats-core/wiki/Install#install-bats-from-github-release
ARG BATS_VERSION='1.2.1'
ARG BATS_RELEASE="https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz"
RUN batstmp="$(mktemp -d bats-core-"${BATS_VERSION}".XXXXXX)"                 \
    && pushd "${batstmp}" &> /dev/null || return 11                           \
    && curl -sSLO "${BATS_RELEASE}"                                           \
    && tar -zxvf v"${BATS_VERSION}".tar.gz                                    \
    && sudo bash "${batstmp}/bats-core-${BATS_VERSION}/install.sh" /usr/local \
    && popd &> /dev/null || return 12                                         \
    && command -v bats && rm -rf "${batstmp}"

ARG PROJECT_ROOT='/var/project'
WORKDIR $PROJECT_ROOT
