#!/usr/bin/env bats

@test "git version" {
  run bash -c "docker exec circleci-remote-docker-ubuntu-edge git --version"
  [[ "${output}" =~ "2.45" ]]
}

@test "openssh-server version" {
  run bash -c "docker exec circleci-remote-docker-ubuntu-edge ssh -V"
  [[ "${output}" =~ "9.7" ]]
}

@test "tar version" {
  run bash -c "docker exec circleci-remote-docker-ubuntu-edge tar --version"
  [[ "${output}" =~ "1.35" ]]
}

@test "gzip version" {
  run bash -c "docker exec circleci-remote-docker-ubuntu-edge gzip --version"
  [[ "${output}" =~ "1.12" ]]
}

@test "ca-certificates installed" {
  run bash -c "docker exec circleci-remote-docker-ubuntu-edge ls /etc/ssl/certs/"
  [[ "${output}" =~ "DigiCert_Assured_ID_Root_CA.pem" ]]
}
