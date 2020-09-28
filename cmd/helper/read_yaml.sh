#!/bin/bash

set -eu

read_yaml()
{
  local path=$1
  local key=$2

  # https://github.com/mikefarah/yq
  cat <"${path}" | yq r - "${key}"
}
