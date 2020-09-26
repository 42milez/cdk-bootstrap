#!/bin/bash

verify_env()
{
  local CURRENT_DIR="$(pwd)"

  local DEVELOPMENT
  local STAGING
  local PRODUCTION

  DEVELOPMENT=$(cat <"${CURRENT_DIR}/cmd/config.yml" | yq r - 'env.development')
  STAGING=$(cat <"${CURRENT_DIR}/cmd/config.yml" | yq r - 'env.staging')
  PRODUCTION=$(cat <"${CURRENT_DIR}/cmd/config.yml" | yq r - 'env.production')

  case $1 in
    "${DEVELOPMENT}") : 'valid' ;;
    "${STAGING}") : 'valid' ;;
    "${PRODUCTION}") : 'valid' ;;
    *) echo "invalid environment: ${DEVELOPMENT}, ${STAGING} or ${PRODUCTION} is available" && exit 1 ;;
  esac
}
