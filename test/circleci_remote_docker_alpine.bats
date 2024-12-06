#!/usr/bin/env bats

@test "git version" {
  run bash -c "docker exec circleci-remote-docker-alpine-edge git --version"
  [[ "${output}" =~ "2.47" ]]
}

@test "openssh version" {
  run bash -c "docker exec circleci-remote-docker-alpine-edge ssh -V"
  [[ "${output}" =~ "9.9" ]]
}

@test "tar version" {
  run bash -c "docker exec circleci-remote-docker-alpine-edge tar --version"
  [[ "${output}" =~ "1.35" ]]
}

@test "gzip version" {
  run bash -c "docker exec circleci-remote-docker-alpine-edge gzip --version"
  [[ "${output}" =~ "1.13" ]]
}

@test "ca-certificates installed" {
  run bash -c "docker exec circleci-remote-docker-alpine-edge ls /etc/ssl/certs/"
  [[ "${output}" =~ "ca-cert-DigiCert_Assured_ID_Root_CA.pem" ]]
}
