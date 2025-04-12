
<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/psk_banner.png" width=800 />
	</p>
  <h1>twdps/circleci-remote-docker</h1>
  <h3>PSK CircleCI Convenience Images</h3>
  <a href="https://app.circleci.com/pipelines/github/twplatformlabs/circleci-remote-docker"><img src="https://circleci.com/gh/twplatformlabs/circleci-remote-docker.svg?style=shield"></a> <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/circleci-remote-docker"></a>
</div>
<br />

**Debian version deprecated. 2024.08.1 is last update. Moving to ubuntu:24.04 for the Alpine alternative to aligned with CircleCI default environments.**  

With inspiration from the CircleCI convenience images, `twdps/circleci-remote-docker` maintains both Alpine and Ubuntu variants with both remote and self-hosted runners in mind. As the name suggests, this image is designed to serve as a starter image for building a use-tailored CircleCI [remote docker executor](https://circleci.com/docs/2.0/custom-images/#section=configuration).  

This image contains the [minimum packages required](https://circleci.com/docs/custom-images/) to function as a remote_docker executor on CircleCI.  

_difference with cimg libraries._ Enterprise settings often require specific security and configuration testing. The twdps series of convenience images is designed to demonstrate an effective and extensible executor lifecycle architecure.  

**signature**. Images are signed using `cosign`. You can verify an image using the twdps public key found [here](https://raw.githubusercontent.com/twplatformlabs/static/master/cosign.pub).  
```bash
cosign verify --key cosign.pub twdps/circleci-remote-docker:alpine-2023.04
```  

**software bill of materials**. For each published image, an SBOM is generated using [syft](https://github.com/anchore/syft) and uploaded to the container registry tagged using the manifest id and .spdx extension. You can pull the sbom using the oras tool as follows:  

fetch image manifest:  
```
docker image inspect --format='{{index .RepoDigests 0}}' twdps/circleci-remote-docker:alpine-2023.04  

twdps/circleci-remote-docker@sha256:9d8e8eef60900fcf207e3b258b4ce13b4cdb1765f0f7ca3022fd685cd53b8a14
```

download sbom:  
```
oras pull docker.io/twdps/circleci-remote-docker:sha256-9d8e8eef60900fcf207e3b258b4ce13b4cdb1765f0f7ca3022fd685cd53b8a14.spdx
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

This image intended to be used as the FROM image in a custom CircleCI remote docker executor.  

For example:

```Dockerfile
FROM twdps/circleci-remote-docker:2021.09  

ENV NODE_VERSION=12.16.3

RUN curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
	sudo tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
	rm node.tar.xz && \
	sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs
```

The tag `2025.01` indicates that the version of the base image used will be the January 2025 release.  
See how tags work below for more information.  

## What is Included in the Image

This image is maintained with both an Alpine and Debian Linux based distribution and contains the minimum requirements needed to be used as a remote docker executor on CircleCI:  

- bash
- git
- openssh
- tar
- gzip
- ca-certificates

_See release notes or distribution dockerfiles for specific versions_

### Tagging Scheme

This image has the following tagging scheme:

```
twdps/circleci-remote-docker:edge
twdps/circleci-remote-docker:stable
twdps/circleci-remote-docker:<YYYY.MM>
```

`<YYYY.MM>` - Release version of the image, referred to by the 4 digit year, dot, and a 2 digit month. For example `2020.05` would be the monthly tag from May 2020. This image is generated monthly, based on the then current release of the base image and related packages and provides a predictable fixed point for use in an executor Dockerfile. Occasionally there will be interim patches released and you may see `2021.08.1` or addtional numbered versions.  

`stable` - generic tag that always points to the latest, monthly release image. Provides a decent level of stability while recieving all software updates and recommended security patches.  

`edge` - is the latest development of the Base image. Built from the `HEAD` of the `main` branch. Intended to be used as a testing version of the image with the most recent changes.  

Review the build and CVE scan logs in the release artifacts for specific packages versions and known vulnerabilities (if any).

## Contributing

We encourage [issues](https://github.com/twdps/circleci-remote-docker/issues) and [pull requests](https://github.com/twdps/circleci-remote-docker/pulls) against this repository. In order to value your time, here are some things to consider:  

1. Intended to be the minimum configuration necessary for an Alpine or Ubuntu based image to be successfully launched by CircleCI as a remote docker executor and specifically does not include any other packages.  
1. PRs are welcome. Given the role of this image as a building block in building CircleCI remote docker executors, it is expected that PRs or Issue will be releated to bugs or compatibility issues. PR's to include additional packages will only be considered where necessary to continue supporting Alpine or Ubuntu linux as a remote docker base.  

**CI requirements**  

[bats](https://github.com/bats-core/bats-core)  
[hadolint](https://github.com/hadolint/hadolint)  
[snyk](https://github.com/snyk/cli)  

## Additional Resources

- [CircleCI Docs](https://circleci.com/docs/)  
- [CircleCI Configuration Reference](https://circleci.com/docs/2.0/configuration-reference/#section=configuration)
