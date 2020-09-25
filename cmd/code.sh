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

set -- "${positional[@]}" # restore positional parameters

#  Set defaults
# --------------------------------------------------

if [ -z "${ENV+UNDEFINED}" ]; then
  readonly ENV='development'
fi

#  Command definitions
# --------------------------------------------------

readonly CMD=$1

if [ "${CMD}" = 'lint' ]; then
{
  find "${PROJECT_ROOT}" -type f -name '*.ts' \
    -not -path "/cdk.out/*" \
    -not -path "${PROJECT_ROOT}/layer.out/*" \
    -not -path "${PROJECT_ROOT}/node_modules/*" \
    -print0 \
  | xargs -0 npx eslint
}
elif [ "${CMD}" = 'build' ]; then
{
  readonly LAMBDA_LAYER_DIR="${PROJECT_ROOT}/layer.out/${ENV}/nodejs"

  mkdir -p "${LAMBDA_LAYER_DIR}"
  cp -p ./package{,-lock}.json "${LAMBDA_LAYER_DIR}"
  sed -i 's/file:\./file:\.\.\/\.\.\/\.\./g' "${LAMBDA_LAYER_DIR}/package.json"

  # install packages without development dependencies
  npm --prefix "${LAMBDA_LAYER_DIR}" install --production

  npx tsc
}
elif [ "${CMD}" = 'test' ]; then
{
  npx jest
}
elif [ "${CMD}" = 'snapshot' ]; then
{
  npx jest --updateSnapshot
}
fi
