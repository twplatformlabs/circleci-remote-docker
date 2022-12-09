
<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 />
    <br />
		<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png" width=350/>
	</p>
  <h3>EMPC Convenience Images</h3>
  <h1>twdps/circleci-remote-docker</h1>
  <a href="https://app.circleci.com/pipelines/github/ThoughtWorks-DPS/circleci-remote-docker"><img src="https://circleci.com/gh/ThoughtWorks-DPS/circleci-remote-docker.svg?style=shield"></a> <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/circleci-remote-docker"></a>
</div>
<br />

With inspiration from the CircleCI convenience images, `twdps/circleci-remote-docker` maintains both alpine and slim variants with both remote and self-hosted runners in mind. As the name suggests, this image is designed to serve as a starter image for building a use-tailored CircleCI [remote docker executor](https://circleci.com/docs/2.0/custom-images/#section=configuration).  

This image contains the minimum packages required to function as a remote_docker executor on CircleCI.  

_difference with cimg libraries._ Enterprise settings often require specific security and configuration testing. The twdps series of convenience images includes common sdlc security practices, including CIS-benchmark testing. Review `.snyk` for current vulnerability status.  

**Other images in this series**  

twdps/circleci-base-image  
twdps/circleci-executor-builder  
twdps/circleci-infra-aws  

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
FROM twdps/circleci-remote-docker:2021.08  

ENV NODE_VERSION=12.16.3

RUN curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
	sudo tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
	rm node.tar.xz && \
	sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs
```

The tag `2021.08` indicates that the version of the base image used will be the August 2021 release.  
See how tags work below for more information.  

## What is Included in the Image

This image is maintained with both an Alpine and Debian Linux based distribution and contains the minimum requirements needed to be used as a remote docker executor on CircleCI:  

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

`<YYYY.MM>` - Release version of the image, referred to by the 4 digit year, dot, and a 2 digit month. For example `2020.05` would be the monthly tag from May 2020. This is the recommended version for use in an executor Dockerfile. Where interim patches are required you may see `2021.08.1` or addtional numbered versions.  

`stable` - generic tag that always points to the latest, monthly release image. Provides a decent level of stability while recieving all software updates and recommended security patches. Security patches can sometimes include pre-release or release candidate versions of packages.  

`edge` - is the latest development of the Base image. Built from the `HEAD` of the `main` branch. Intended to be used as a testing version of the image with the most recent changes.  

Also please note, stable in this case does not always imply general release for underlying components. For example, `sid` is used for the debain image in order to pick up the latest, patch versions of packages to eliminate any median or critical CVE issues.  

## Contributing

We encourage [issues](https://github.com/twdps/circleci-remote-docker/issues) and [pull requests](https://github.com/twdps/circleci-remote-docker/pulls) against this repository. In order to value your time, here are some things to consider:  

1. Intended to be the minimum configuration necessary for an alpine or debain based image to be successfully launched by circleci as a remote docker executor and specifically does not include any other packages.  
1. PRs are welcome. Given the role of this image as a building block in building CircleCI remote docker executors, it is expected that PRs or Issue will be releated to bugs or compatibility issues. PR's to include additional packages will only be considered where necessary to continue supporting Alpine or debian linux as a remote docker base.  

### Local development

Use `test_local.sh` to build and test image locally. In order to successfully run the CIS benchmark test locally you will need a local copy of the CIS Docker benchmark section 4 policy statement. The [orb-executor-tools](https://circleci.com/developer/orbs/orb/twdps/executor-tools) used to build this image includes a standard set of CIS requirements, pull a copy of that file and name it `policy.rego` (which will be ignored by current git settings) for local testing.  

**requirements**  


[bats](https://github.com/bats-core/bats-core)  
[conftest](https://github.com/open-policy-agent/conftest)  
[hadolint](https://github.com/hadolint/hadolint)  

### Publishing Official Images (for Maintainers only)

Git push will trigger the dev-build pipeline. In addition to the tests performed in testlocal.sh, a snyk scan is done to expose any known vulnerabilities.   

To create a release version, simply tag HEAD with the release version format `YYYY.MM`  

## Additional Resources

- [CircleCI Docs](https://circleci.com/docs/)  
- [CircleCI Configuration Reference](https://circleci.com/docs/2.0/configuration-reference/#section=configuration)  
