#!/bin/bash

set -eu

. './util/shellscript/read_yaml.sh'
. './util/shellscript/verify_env.sh'

readonly PROJECT_ROOT=$(pwd)

declare -xr AWS_PROFILE='42milez'

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

if [ -z "${AWS_DEFAULT_REGION+UNDEFINED}" ]; then
  declare -xr AWS_DEFAULT_REGION='ap-northeast-1'
else
  export AWS_DEFAULT_REGION
fi

#  Command definitions
# --------------------------------------------------

readonly CMD=$1

##### BOOTSTRAP #####

if [ "${CMD}" = 'bootstrap' ]; then
{
  npx cdk bootstrap --output "${PROJECT_ROOT}/cdk.out/bootstrap"
  exit 0
}
fi

##### DEPLOY #####

if [ -z "${ENV+UNDEFINED}" ]; then
  readonly ENV='development'
fi

verify_env "${ENV}"

if [ -z "${APP+UNDEFINED}" ]; then
  echo 'invalid argument: --app is required.'
  exit 1
fi

if [ -z "${STACK}" ]; then
  echo 'invalid argument: --stack is required.'
  exit 1
fi

if [ "${CMD}" = 'deploy' ]; then
{
  npx cdk deploy \
    --app "node ${PROJECT_ROOT}/bin/${APP}.js" \
    --output "${PROJECT_ROOT}/cdk.out/${ENV}" \
    "${STACK}-${ENV}"
}
fi
