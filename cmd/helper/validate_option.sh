#!/bin/bash

validate_option()
{
  local cmd
  local sub_cmd
  local current_dir

  cmd=$1
  sub_cmd=$2
  current_dir="$(pwd)"

  while read -r key; do
  {
    ENV_VAL_NAME=$(cat <"${current_dir}/cmd/option.yml" | yq r - --printMode v "${cmd}.${sub_cmd}.${key}.name")

    if [ -z "${!ENV_VAL_NAME+UNDEFINED}" ]; then
      echo "${key} is required."
      exit 1
    fi
  }
  done < <(cat <"${current_dir}/cmd/option.yml" \
    | yq r - -j "${cmd}}"                       \
    | jq -r ".${sub_cmd}} | with_entries(select((.value|.required) == true)) | keys[]")
}
