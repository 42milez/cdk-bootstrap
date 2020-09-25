#!/bin/bash

set -eu

. './lib/shellscript/read_yaml.sh'
. './lib/shellscript/verify_env.sh'

readonly PROJECT_ROOT=$(pwd)
readonly CDK_OUT_DIR='cdk.out'

#  Parse command-line options
# --------------------------------------------------
#  references:
#  - How do I parse command line arguments in Bash?
#    https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

positional=()

while [ $# -gt 0 ]; do
  opt=$(read_yaml "${PROJECT_ROOT}/cmd/option.yml" "cdk.$1")

  if [ -z "${opt}" ]; then
    positional+=("$1")
    shift
    continue
  fi

  eval "readonly ${opt}=$2"

  shift
  shift
done

set -- "${positional[@]}" # restore positional parameters

#  Set defaults
# --------------------------------------------------

readonly CONFIG_FILE="${PROJECT_ROOT}/cmd/config.yml"

if [ -z "${AWS_PROFILE+UNDEFINED}" ]; then
  readonly AWS_PROFILE=$(read_yaml "${CONFIG_FILE}" 'cli.profile')
  export AWS_PROFILE
fi

if [ -z "${AWS_DEFAULT_REGION+UNDEFINED}" ]; then
  readonly AWS_DEFAULT_REGION=$(read_yaml "${CONFIG_FILE}" 'cli.region')
  export AWS_DEFAULT_REGION
fi

export AWS_PROFILE
export AWS_DEFAULT_REGION

#  Command definitions
# --------------------------------------------------

readonly NPX="docker run --rm -v ${PROJECT_ROOT}:/tmp/npm -w /tmp/npm node:14.11.0-alpine3.11 npx"
readonly CMD=$1

# BOOTSTRAP

if [ "${CMD}" = 'bootstrap' ]; then
{
  npx cdk bootstrap -o "${PROJECT_ROOT}/cdk.out/bootstrap"
  exit 0
}
fi

# LIST / DEPLOY / DESTROY / SYNTH

if [ -z "${ENV+UNDEFINED}" ]; then
{
  readonly ENV='development'
}
fi

verify_env "${ENV}"

if [ "${CMD}" = 'list' ]; then
{
  $NPX cdk list -o "${PROJECT_ROOT}/cdk.out/${ENV}" -c "env=${ENV}"
  exit 0
}
fi

if [ -z "${STACK+UNDEFINED}" ]; then
{
  echo 'invalid argument: --stack is required.'
  exit 1
}
fi

if [ "${CMD}" = 'deploy' ]; then
{
  $NPX cdk deploy -o "${PROJECT_ROOT}/${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" "${STACK}-${ENV}"
}
elif [ "${CMD}" = 'destroy' ]; then
{
  $NPX cdk destroy -o "${PROJECT_ROOT}/${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" "${STACK}-${ENV}"
}
elif [ "${CMD}" = 'synth' ]; then
{
  $NPX cdk synth -o "${PROJECT_ROOT}/${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" "${STACK}-${ENV}"
}
else
{
  echo "invalid command: ${CMD} is not defined"
}
fi
