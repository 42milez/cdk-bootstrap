#!/usr/bin/env bats

setup() {
  . "$(pwd)/cmd/helper/read_yaml.sh"
  readonly YAML_PATH="$(pwd)/test/bash/read_yaml_test.yml"
}

@test 'read_yaml() can read string' {
  run read_yaml "${YAML_PATH}" 'obj.string'
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Hello YAML" ]
}

@test 'read_yaml() can read value of array' {
  run read_yaml "${YAML_PATH}" 'obj.array[0]'
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 1 ]
}
