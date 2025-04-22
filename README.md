<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/psk_banner.png" width=800 />
	</p>
  <h1>twdps/circleci-remote-docker</h1>
  <h3>PSK CircleCI Convenience Images</h3>
  <a href="https://app.circleci.com/pipelines/github/twplatformlabs/circleci-remote-docker"><img src="https://circleci.com/gh/twplatformlabs/circleci-remote-docker.svg?style=shield"></a> <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/circleci-remote-docker"></a>
</div>
<br />

With inspiration from the CircleCI convenience images, `twdps/circleci-remote-docker` maintains Alpine and Ubuntu variants with both remote and self-hosted runners in mind. As the name suggests, this image is designed to serve as a starter image for building a use-tailored CircleCI [remote docker executor](https://circleci.com/docs/2.0/custom-images/#section=configuration).  

This image contains the [minimum packages required](https://circleci.com/docs/custom-images/) to function as a remote_docker executor on CircleCI.  

_difference with cimg libraries._ Enterprise settings often require specific security and configuration testing. The twdps series of convenience images is designed to demonstrate an effective, automated executor lifecycle architecture.  

**signature**. Images are signed using `cosign`. Verify images using the twplatformlabs [public key](https://raw.githubusercontent.com/twplatformlabs/static/master/cosign.pub).  
```bash
cosign verify --key cosign.pub twdps/circleci-remote-docker:alpine-2025.04
```  
**software bill of materials**. For each published image, a _Software Bill of Materials_ is generated using [syft](https://github.com/anchore/syft) and added as an attestation.  

validate attestation:  
```bash
cosign verify-attestation --type https://spdx.dev/Document --key cosign.pub twdps/circleci-remote-docker:alpine-2025.04
```
download manifest and extract bill of materials (sbom.spdx.json):  
```
cosign download attestation twdps/circleci-remote-docker:alpine-2025.04 > attestation.json  
jq -r '.payload' attestation.json | base64 -d > envelope.json
jq '.predicate' envelope.json > sbom.spdx.json
```

**Other images in this series**  

twdps/circleci-base-image  
twdps/circleci-executor-builder  
twdps/circleci-infra-aws  
twdps/kube-ops

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
- [What is Included in the Image](#what-is-included-in-the-image)
	- [Tagging Scheme](#tagging-scheme)
- [Contributing](#contributing)
	- [Local development](#local-development)
	- [Publishing Official Images (for Maintainers only)](#publishing-official-images-for-maintainers-only)
- [Additional Resources](#additional-resources)

## Getting Started

This image is intended to be used as the FROM image in a custom CircleCI remote docker executor.  

For example:

```Dockerfile
FROM twdps/circleci-remote-docker:2025.04  

ENV NODE_VERSION=12.16.3

RUN curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
	sudo tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
	rm node.tar.xz && \
	sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs
```

The tag `2025.01` indicates that the image was created in January 2025. Monthly, automated image builds occur on the 5th of each month.  

## What is Included in the Image

Two flavors of this image are maintained:  

- alpine:3
- ubuntu:24.04

Each contains the minimum requirements needed, as defined by CircleCI, to be used as a remote docker executor:  

- bash
- git
- openssh
- tar
- gzip
- ca-certificates

_Review the build and CVE scan logs in the release artifacts of the monthly build for specific package versions and known vulnerabilities (if any)._

### Tagging Scheme

This image has the following tagging scheme:

```
twdps/circleci-remote-docker:<YYYY.MM>
twdps/circleci-remote-docker:stable
twdps/circleci-remote-docker:edge
```

`<YYYY.MM>` - Release version of the image, referred to by the four-digit year and two-digit month. For example, `2025.04` would be the April 2025 build. This image is generated on the 5th day of each month, pulling the current release of the base image and related packages and provides a predictable fixed point for use in an executor Dockerfile. Review the build log in the pipeline artifacts for the specific image and package versions. Occasionally, there will be interim patch released and you may see `YYYY.MM.1` or additional further numbered versions.  

`stable` - generic tag that always points to the latest, monthly release image. Intended for use by other recurring builds and not recommended for normal executor Dockerfile usage. Pin custom executors to specific month-tagged base images.  

`edge` - is the latest development of the Base image. Built from the `HEAD` of the `main` branch as part of continuous integration testing.  

## Contributing

We encourage [issues](https://github.com/twplatformlabs/circleci-remote-docker/issues) and [pull requests](https://github.com/twplatformlabs/circleci-remote-docker/pulls) against this repository. In order to value your time, here are some things to consider:  

1. Intended to be the minimum configuration necessary for an Alpine or Ubuntu based image to be successfully launched by CircleCI as a remote docker executor and intentionally does not include any other packages.  
1. PRs are welcome. Given the role of this image as a building block in building CircleCI remote docker executors, it is expected that PRs or Issues will be releated to bugs or compatible purpose issues. PR's to include additional packages will only be considered where necessary to continue supporting Alpine or Ubuntu linux as a remote docker starting point.  

**CI requirements**  

[bats](https://github.com/bats-core/bats-core)  
[hadolint](https://github.com/hadolint/hadolint)  
[snyk](https://github.com/snyk/cli)  

## Additional Resources

- [CircleCI Docs](https://circleci.com/docs/)  
- [CircleCI Configuration Reference](https://circleci.com/docs/2.0/configuration-reference/#section=configuration)
