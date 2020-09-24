#!/bin/bash

readonly DEVELOPMENT='development'
readonly STAGING='staging'
readonly PRODUCTION='production'

verify_env() {
  case $1 in
    "${DEVELOPMENT}") : 'valid' ;;
    "${STAGING}") : 'valid' ;;
    "${PRODUCTION}") : 'valid' ;;
    *) ConsoleError "invalid environment (${DEVELOPMENT}, ${STAGING} or ${PRODUCTION} is available)" \
       && exit 1 ;;
  esac
}
