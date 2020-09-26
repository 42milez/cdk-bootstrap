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
readonly BASH_CMD='docker-compose run --rm bash'
readonly NPX_CMD='docker-compose run --rm npx'
readonly CMD=$1

# LINT

if [ "${CMD}" = 'lint' ]; then
{
  targets=()

  while read -r path; do
  {
    targets+=("$(echo "${path}" | perl -pe "s|${PROJECT_ROOT}|${DOCKER_WORK_DIR}|g")")
  }
  done < <(find                                 \
    "${PROJECT_ROOT}"                           \
    -type f                                     \
    -name '*.ts'                                \
    -not -path "${PROJECT_ROOT}/cdk.out/*"      \
    -not -path "${PROJECT_ROOT}/layer.out/*"    \
    -not -path "${PROJECT_ROOT}/node_modules/*")

  # shellcheck disable=SC2086
  $NPX_CMD eslint ${targets[*]}
}
fi

# BUILD / TEST / SNAPSHOT

if [ -z "${ENV+UNDEFINED}" ]; then
{
  readonly ENV='development'
}
fi

verify_env "${ENV}"

if [ "${CMD}" = 'build' ]; then
{
  : 'PREPARE LAMBDA LAYER' &&
  {
    readonly LAMBDA_LAYER_SRC_DIR="${PROJECT_ROOT}/src/function/layer"
    readonly LAMBDA_LAYER_DEST_DIR="layer.out/${ENV}"

    commands=()

    while read -r dir; do
    {
      install_dir="${LAMBDA_LAYER_DEST_DIR}/${dir}/nodejs"
      mkdir -p "${install_dir}"
      cp "${LAMBDA_LAYER_SRC_DIR}/${dir}/package.json" "${install_dir}"

      # add 'dependencies' member if not exists
      if [ "$(jq '.dependencies?' "${install_dir}/package.json")" = 'null' ]; then
      {
        cat < "${install_dir}/package.json"                                   \
          | jq ". |= .+ {\"dependencies\": {}}"                               \
          > "${install_dir}/package-tmp.json"                                 \
        && mv "${install_dir}/package-tmp.json" "${install_dir}/package.json"
      }
      fi

      layer_name=$(jq -r '.name' "${install_dir}/package.json")

      # add self as a dependency
      cat < "${install_dir}/package.json"                                                         \
        | jq ".dependencies |= .+ {\"${layer_name}\": \"../../../../src/function/layer/${dir}\"}" \
        > "${install_dir}/package-tmp.json"                                                       \
      && mv "${install_dir}/package-tmp.json" "${install_dir}/package.json"

      # install 'dependencies' without 'devDependencies'
      commands+=("npm --prefix ${install_dir} install --production")
    }
    done < <(find "${LAMBDA_LAYER_SRC_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

    cmd=$(IFS=',' tmp="${commands[*]}" ; echo "${tmp//,/ && }")

    # install packages without development dependencies
    $BASH_CMD -c "${cmd}"
  }

  : 'TRANSPILE ALL .ts FILES' &&
  {
    $NPX_CMD tsc
  }
}
elif [ "${CMD}" = 'test' ]; then
{
  $NPX_CMD jest
}
elif [ "${CMD}" = 'snapshot' ]; then
{
  $NPX_CMD jest --updateSnapshot
}
else
{
  echo "invalid command: ${CMD} is not defined"
}
fi
