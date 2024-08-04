#!/usr/bin/env bats

@test "git version" {
  run bash -c "docker exec circleci-remote-docker-slim-edge git --version"
  [[ "${output}" =~ "2.45" ]]
}

@test "openssh-server version" {
  run bash -c "docker exec circleci-remote-docker-slim-edge ssh -V"
  [[ "${output}" =~ "9.8" ]]
}

@test "tar version" {
  run bash -c "docker exec circleci-remote-docker-slim-edge tar --version"
  [[ "${output}" =~ "1.35" ]]
}

@test "gzip version" {
  run bash -c "docker exec circleci-remote-docker-slim-edge gzip --version"
  [[ "${output}" =~ "1.12" ]]
}

@test "ca-certificates installed" {
  run bash -c "docker exec circleci-remote-docker-slim-edge ls /etc/ssl/certs/"
  [[ "${output}" =~ "DigiCert_Assured_ID_Root_CA.pem" ]]
}
