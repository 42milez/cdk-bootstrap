#!/bin/bash
# shellcheck disable=SC1090

# References
# - SAM CLI:
#   https://docs.aws.amazon.com/cdk/latest/guide/sam.html

set -eu

readonly PROJECT_ROOT=$(pwd)

. "${PROJECT_ROOT}/cmd/helper/read_yaml.sh"
. "${PROJECT_ROOT}/cmd/helper/validate_env.sh"

#  Parse command-line options
# --------------------------------------------------
#  references:
#  - How do I parse command line arguments in Bash?
#    https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

positional=()

while [ $# -gt 0 ]; do
{
  opt=$(read_yaml "${PROJECT_ROOT}/cmd/option.yml" "sam.$1")

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

#  Command definitions
# --------------------------------------------------

readonly CMD=$1
readonly CFN_TEMPLATE_DIR="${PROJECT_ROOT}/cdk.out/development"
readonly EVENT_DATA_DIR="${PROJECT_ROOT}/src/sam/event"

# INVOKE

if [ "${CMD}" = 'invoke' ]; then
{
  if [ -z "${EVENT_DATA+UNDEFINED}" ]; then
    readonly EVENT_OPTION='--no-event'
  else
    readonly EVENT_OPTION="--event ${EVENT_DATA_DIR}/${EVENT_DATA}"
  fi

  # shellcheck disable=SC2086
  sam local invoke                                              \
    "${FID}"                                                    \
    -t "${CFN_TEMPLATE_DIR}/${STACK}-development.template.json" \
    ${EVENT_OPTION}
}
fi
