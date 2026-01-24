#!/usr/bin/env bats

setup() {
  if [[ -z "${TEST_CONTAINER}" ]]; then
    echo "ERROR: TEST_CONTAINER environment variable is not set"
    echo "Example:"
    echo "  TEST_CONTAINER=my-container bats tests.bats"
    exit 1
  fi
}

@test "git version" {
  run bash -c "docker exec ${TEST_CONTAINER} git --help"
  [[ "${output}" =~ "git" ]]
}

@test "openssh version" {
  run bash -c "docker exec ${TEST_CONTAINER} ssh -V"
  [[ "${output}" =~ "OpenSSH" ]]
}

@test "tar version" {
  run bash -c "docker exec ${TEST_CONTAINER} tar --help"
  [[ "${output}" =~ "tar" ]]
}

@test "gzip version" {
  run bash -c "docker exec ${TEST_CONTAINER} gzip --help"
  [[ "${output}" =~ "gzip" ]]
}

@test "ca-certificates installed" {
  run bash -c "docker exec ${TEST_CONTAINER} ls /etc/ssl/certs/"
  [[ "${output}" =~ "DigiCert_Assured_ID_Root_CA.pem" ]]
}
