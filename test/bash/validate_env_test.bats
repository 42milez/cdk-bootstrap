#!/usr/bin/env bats

setup() {
  . "$(pwd)/cmd/helper/validate_env.sh"
}

@test "validate_env() can permit 'development' environment" {
  run validate_env 'development'
  [ "$status" -eq 0 ]
}

@test "validate_env() cannot permit 'dev' environment" {
  run validate_env 'dev'
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = 'invalid environment: development, staging or production is available' ]
}
