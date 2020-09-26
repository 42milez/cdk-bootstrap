#!/bin/bash
# shellcheck disable=SC1090

set -eu

readonly PROJECT_ROOT=$(pwd)

. "${PROJECT_ROOT}/cmd/helper/read_yaml.sh"
. "${PROJECT_ROOT}/cmd/helper/verify_env.sh"

#  Parse command-line options
# --------------------------------------------------
#  references:
#  - How do I parse command line arguments in Bash?
#    https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

positional=()

while [ $# -gt 0 ]; do
{
  opt=$(read_yaml "${PROJECT_ROOT}/cmd/option.yml" "cdk.$1")

  if [ -z "${opt}" ]; then
    positional+=("$1")
    shift
    continue
  fi

  eval "readonly ${opt}=$2"

  shift
  shift
}
done

set -- "${positional[@]}" # restore positional parameters

#  Set defaults
# --------------------------------------------------

readonly CONFIG_FILE="${PROJECT_ROOT}/cmd/config.yml"

if [ -z "${AWS_PROFILE+UNDEFINED}" ]; then
{
  readonly AWS_PROFILE=$(read_yaml "${CONFIG_FILE}" 'cli.profile')
  export AWS_PROFILE
}
fi

if [ -z "${AWS_DEFAULT_REGION+UNDEFINED}" ]; then
{
  readonly AWS_DEFAULT_REGION=$(read_yaml "${CONFIG_FILE}" 'cli.region')
  export AWS_DEFAULT_REGION
}
fi

export AWS_PROFILE
export AWS_DEFAULT_REGION

#  Command definitions
# --------------------------------------------------

readonly CMD=$1
readonly CDK_CMD="docker-compose run
  -e AWS_PROFILE=${AWS_PROFILE}
  -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
  --rm cdk"
readonly DOCKER_WORK_DIR='/var/project'
readonly CDK_OUT_DIR="${DOCKER_WORK_DIR}/cdk.out"

# BOOTSTRAP

if [ "${CMD}" = 'bootstrap' ]; then
{
  $CDK_CMD bootstrap -o "${CDK_OUT_DIR}/bootstrap"
  exit 0
}
fi

# LIST / DEPLOY / DESTROY / SYNTH

if [ -z "${ENV+UNDEFINED}" ]; then
{
  readonly ENV=$(read_yaml "${PROJECT_ROOT}/cmd/config.yml" 'env.development')
}
fi

verify_env "${ENV}"

if [ "${CMD}" = 'list' ]; then
{
  $CDK_CMD list -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}"
  exit 0
}
fi

if [ -z "${STACK+UNDEFINED}" ]; then
{
  echo 'invalid argument: --stack is required.'
  exit 1
}
fi

stacks=()

# shellcheck disable=SC2207,SC2116
while read -r s; do
{
  stacks+=("${s}-${ENV}")
}
done < <(echo "$(IFS=',' tmp=($(echo "${STACK}")) ; printf '%s\n' "${tmp[@]}")")

synth()
{
  local stacks_=$1

  # shellcheck disable=SC2086
  $CDK_CMD synth -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" ${stacks_}
}

if [ "${CMD}" = 'deploy' ]; then
{
  # shellcheck disable=SC2086
  $CDK_CMD deploy -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" ${stacks[*]}

  synth "${stacks[*]}"
}
elif [ "${CMD}" = 'destroy' ]; then
{
  # shellcheck disable=SC2086
  $CDK_CMD destroy -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" ${stacks[*]}
}
elif [ "${CMD}" = 'synth' ]; then
{
  synth "${stacks[*]}"
}
else
{
  echo "invalid command: ${CMD} is not defined"
}
fi
