#!/bin/bash

setup() {
  . "$(pwd)/cmd/helper/validate_option.sh"
}

@test 'validate_option() can permit valid option' {
  run validate_option 'cdk' 'deploy'
  [ "$status" -eq 0 ]
}
