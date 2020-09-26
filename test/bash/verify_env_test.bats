#!/usr/bin/env bats

setup() {
  . "$(pwd)/cmd/helper/verify_env.sh"
}

@test "verify_env() can permit 'development' environment" {
  run verify_env 'development'
  [ "$status" -eq 0 ]
}

@test "verify_env() cannot permit 'dev' environment" {
  run verify_env 'dev'
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = 'invalid environment: development, staging or production is available' ]
}
