#!/bin/bash
# shellcheck disable=SC1090

set -eu

readonly PROJECT_ROOT=$(pwd)

. "${PROJECT_ROOT}/cmd/helper/read_yaml.sh"
. "${PROJECT_ROOT}/cmd/helper/validate_env.sh"
. "${PROJECT_ROOT}/cmd/helper/validate_option.sh"

# --------------------------------------------------
#  Parse Command-Line Options
# --------------------------------------------------
#  references:
#  - How do I parse command line arguments in Bash?
#    https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

positional=()

while [ $# -gt 0 ]; do
{
  opt=$(read_yaml "${PROJECT_ROOT}/cmd/option.yml" "cdk.$1.val")

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

# --------------------------------------------------
#  Setup
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

if [ -z "${ENV+UNDEFINED}" ]; then
  readonly ENV=$(read_yaml "${PROJECT_ROOT}/cmd/config.yml" 'env.development')
fi

validate_env "${ENV}"

if [ -n "${STACK+UNDEFINED}" ]; then
{
  stacks=()

  # shellcheck disable=SC2207,SC2116
  while read -r s; do
    stacks+=("${s}-${ENV}")
  done < <(echo "$(IFS=',' tmp=($(echo "${STACK}")) ; printf '%s\n' "${tmp[@]}")")
}
fi

export AWS_PROFILE
export AWS_DEFAULT_REGION

# --------------------------------------------------
#  Command Definitions
# --------------------------------------------------

readonly CMD=$1
readonly CDK_CMD="docker-compose run -e AWS_PROFILE=${AWS_PROFILE} -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} --rm cdk"
readonly DOCKER_WORK_DIR='/var/project'
readonly CDK_OUT_DIR="${DOCKER_WORK_DIR}/cdk.out"

if [ "${CMD}" = 'bootstrap' ]; then
{
  validate_option 'cdk' 'bootstrap'

  $CDK_CMD bootstrap -o "${CDK_OUT_DIR}/bootstrap"
}
elif [ "${CMD}" = 'deploy' ]; then
{
  validate_option 'cdk' 'deploy'

  # shellcheck disable=SC2086
  $CDK_CMD deploy -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" ${stacks[*]}
}
elif [ "${CMD}" = 'list' ]; then
{
  validate_option 'cdk' 'list'

  $CDK_CMD list -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}"
}
elif [ "${CMD}" = 'destroy' ]; then
{
  validate_option 'cdk' 'destroy'

  # shellcheck disable=SC2086
  $CDK_CMD destroy -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" ${stacks[*]}
}
elif [ "${CMD}" = 'synth' ]; then
{
  validate_option 'cdk' 'synth'

  # shellcheck disable=SC2086
  $CDK_CMD synth -o "${CDK_OUT_DIR}/${ENV}" -c "env=${ENV}" ${stacks[*]}
}
else
  echo "invalid command: ${CMD} is not defined"
fi
