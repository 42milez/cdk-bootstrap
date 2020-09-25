#!/bin/bash

verify_env()
{
  local DEVELOPMENT='development'
  local STAGING='staging'
  local PRODUCTION='production'

  case $1 in
    "${DEVELOPMENT}") : 'valid' ;;
    "${STAGING}") : 'valid' ;;
    "${PRODUCTION}") : 'valid' ;;
    *) echo "invalid environment: ${DEVELOPMENT}, ${STAGING} or ${PRODUCTION} is available" && exit 1 ;;
  esac
}
