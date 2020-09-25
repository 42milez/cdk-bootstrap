#!/bin/bash

set -eu

. './lib/shellscript/read_yaml.sh'
. './lib/shellscript/verify_env.sh'

readonly PROJECT_ROOT=$(pwd)

#  Parse command-line options
# --------------------------------------------------

positional=()

while [ $# -gt 0 ]; do
  opt=$(read_yaml "${PROJECT_ROOT}/cmd/option.yml" "code.$1")

  # skip positional argument
  if [ -z "${opt}" ]; then
    positional+=("$1")
    shift
    continue
  fi

  # define variable
  eval "readonly ${opt}=$2"

  shift
  shift
done

set -- "${positional[@]}"

#  Set defaults
# --------------------------------------------------

if [ -z "${ENV+UNDEFINED}" ]; then
  readonly ENV='development'
fi

#  Command definitions
# --------------------------------------------------

readonly DOCKER_WORK_DIR='/var/project'
readonly NPM_CMD='docker-compose run --rm npm'
readonly NPX_CMD='docker-compose run --rm npx'
readonly CMD=$1

if [ "${CMD}" = 'lint' ]; then
{
  targets=()

  while read -r path; do
  {
    targets+=("$(echo "${path}" | perl -pe "s|${PROJECT_ROOT}|${DOCKER_WORK_DIR}|g")")
  }
  done < <(find \
    "${PROJECT_ROOT}" \
    -type f \
    -name '*.ts' \
    -not -path "${PROJECT_ROOT}/cdk.out/*" \
    -not -path "${PROJECT_ROOT}/layer.out/*" \
    -not -path "${PROJECT_ROOT}/node_modules/*")

  # shellcheck disable=SC2086
  $NPX_CMD eslint ${targets[*]}
}
elif [ "${CMD}" = 'build' ]; then
{
  readonly LAMBDA_LAYER_DIR="layer.out/${ENV}/nodejs"

  mkdir -p "${LAMBDA_LAYER_DIR}"
  cp -p ./package{,-lock}.json "${LAMBDA_LAYER_DIR}"
  sed -i 's/file:\./file:\.\.\/\.\.\/\.\./g' "${PROJECT_ROOT}/${LAMBDA_LAYER_DIR}/package.json"

  # install packages without development dependencies
  $NPM_CMD --prefix "${DOCKER_WORK_DIR}/${LAMBDA_LAYER_DIR}" install --production

  $NPX_CMD tsc
}
elif [ "${CMD}" = 'test' ]; then
{
  $NPX_CMD jest
}
elif [ "${CMD}" = 'snapshot' ]; then
{
  $NPX_CMD jest --updateSnapshot
}
fi
