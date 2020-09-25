#!/bin/bash

set -eu

. './lib/shellscript/read_yaml.sh'
. './lib/shellscript/verify_env.sh'

readonly PROJECT_ROOT=$(pwd)

#  Parse command-line options
# --------------------------------------------------
#  references:
#    - How do I parse command line arguments in Bash?
#      https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

readonly OPTION_FILE="${PROJECT_ROOT}/cmd/option.yml"

positional=()

while [ $# -gt 0 ]; do
  opt=$(read_yaml "${OPTION_FILE}" "cdk.$1")

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

if [ -z "${AWS_PROFILE}" ]; then
  readonly AWS_PROFILE=$(read_yaml"${CONFIG_FILE}" 'cli.profile')
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

readonly CMD=$1

# BOOTSTRAP

if [ "${CMD}" = 'bootstrap' ]; then
{
  npx cdk bootstrap --app "node ${PROJECT_ROOT}/bin/cdk-bootstrap-2.js" --output "${PROJECT_ROOT}/cdk.out/bootstrap"
  exit 0
}
fi

# DEPLOY / DESTROY

if [ -z "${ENV+UNDEFINED}" ]; then
  declare -xr ENV='development'
fi

verify_env "${ENV}"

if [ -z "${STACK+UNDEFINED}" ]; then
  echo 'invalid argument: --stack is required.'
  exit 1
fi

if [ "${CMD}" = 'deploy' ]; then
{
  npx cdk deploy --output "${PROJECT_ROOT}/cdk.out/${ENV}" "${STACK}-${ENV}"
}
elif [ "${CMD}" = 'destroy' ]; then
{
  npx cdk destroy --output "${PROJECT_ROOT}/cdk.out/${ENV}" "${STACK}-${ENV}"
}
fi
