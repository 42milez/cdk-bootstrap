#!/bin/bash

read_yaml()
{
  readonly FILE_PATH=$1
  readonly KEY=$2

  # https://github.com/mikefarah/yq
  cat <"${FILE_PATH}" | yq r - "${KEY}"
}
