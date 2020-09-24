#!/bin/bash

set -eu

. './util/shellscript/read_yaml.sh'
. './util/shellscript/verify_env.sh'

readonly PROJECT_ROOT=$(pwd)

#  Parse command-line options
# --------------------------------------------------
#  references:
#    - How do I parse command line arguments in Bash?
#      https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

readonly OPTION_FILE="${PROJECT_ROOT}/option.yml"
readonly OPTION_ROOT='option.cdk'

positional=()

while [ $# -gt 0 ]; do
  opt=$(read_yaml "${OPTION_FILE}" "${OPTION_ROOT}.$1")

  if [ -z "${opt}" ]; then
    positional+=("$1")
    shift # past option
    continue
  fi

  eval "readonly ${opt}=$2"

  shift # past key
  shift # past value
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
  readonly LAYER_DIR="${PROJECT_ROOT}/layer.out/${ENV}/nodejs"

  mkdir -p "${LAYER_DIR}"
  cp -p ./package{,-lock}.json "${LAYER_DIR}"
  sed -i 's/file:\./file:\.\.\/\.\.\/\.\./g' "${LAYER_DIR}/package.json"

  # install packages without development dependencies
  npm --prefix "${LAYER_DIR}" install --production

  npm run build
}
elif [ "${CMD}" = 'test' ]; then
{
  npm run test
}
elif [ "${CMD}" = 'snapshot' ]; then
{
  npm run snapshot
}
fi
