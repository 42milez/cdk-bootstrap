#!/bin/bash

setup() {
  . "$(pwd)/cmd/helper/validate_option.sh"
}

@test 'When all required options are provided, it should exit with code 0' {
  STACK='stack'
  run validate_option 'cdk' 'deploy'
  [ "$status" -eq 0 ]
}

@test 'When some required options are not provided, it should exit with code 1' {
  run validate_option 'cdk' 'deploy'
  [ "$status" -eq 1 ]
}
