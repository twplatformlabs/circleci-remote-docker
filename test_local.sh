#!/usr/bin/env bash
_() { echo 'cleanup'; docker rm -f di-circleci-base-image-alpine-edge; docker rmi -f twdps/di-circleci-base-image:alpine-edge; docker rm -f di-circleci-base-image-slim-edge; docker rmi -f twdps/di-circleci-base-image:slim-edge ; }
trap _ EXIT

type=${1:-'pinned'}
alpine_dockerfile='Dockerfile.alpine'
slim_dockerfile='Dockerfile.slim'

echo "CIS Benchmark..."
conftest test Dockerfile.alpine --policy . --data .conftest

# lint Dockerfiles
echo "Linting Dockerfiles..."
hadolint Dockerfile.alpine
hadolint Dockerfile.slim

# pass unpinned as a parameter to this script to test the unpinned
# package definitions for early detection of upcoming breaking changes
if [[ $type == "unpinned" ]]; then
  alpine_dockerfile='Dockerfile.alpine.unpinned'
  slim_dockerfile='Dockerfile.slim.unpinned'
fi

echo "build twdps/di-circleci-base-image:alpine"
docker build -t twdps/di-circleci-base-image:alpine-edge -f $alpine_dockerfile .
echo "build twdps/di-circleci-base-image:slim"
docker build -t twdps/di-circleci-base-image:slim-edge -f $slim_dockerfile .

echo "run image configuration tests"
docker run -it -d --name di-circleci-base-image-alpine-edge --entrypoint "/bin/ash" twdps/di-circleci-base-image:alpine-edge
docker run -it -d --name di-circleci-base-image-slim-edge --entrypoint "/bin/bash" twdps/di-circleci-base-image:slim-edge
bats test


cosign sign --key cosign.key --annotations sbom="$(cat sbom.json)" $(cat manifestid) -y
