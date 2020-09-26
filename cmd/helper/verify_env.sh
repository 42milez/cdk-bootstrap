#!/bin/bash

verify_env()
{
  local current_dir
  local development
  local staging
  local production

  current_dir="$(pwd)"
  development=$(cat <"${current_dir}/cmd/config.yml" | yq r - 'env.development')
  staging=$(cat <"${current_dir}/cmd/config.yml" | yq r - 'env.staging')
  production=$(cat <"${current_dir}/cmd/config.yml" | yq r - 'env.production')

  case $1 in
    "${development}") : 'valid' ;;
    "${staging}")     : 'valid' ;;
    "${production}")  : 'valid' ;;
    *) echo "invalid environment: ${development}, ${staging} or ${production} is available" && exit 1 ;;
  esac
}
