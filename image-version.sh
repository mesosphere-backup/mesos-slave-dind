#!/usr/bin/env bash

# Prints the image version to be used for the Docker image tag

image=${1:-}
[ -z "${image}" ] && echo "No image supplied" && exit 1

# Get image version
wrapper_version=$(docker run --rm --entrypoint bash "${image}" -c 'echo ${WRAPPER_VERSION}')

# Get mesos-slave version
mesos_version=$(docker run --rm --entrypoint bash "${image}" -c "mesos-slave --version | tr -s ' ' | cut -d ' ' -f 2")

# Get docker version from DOCKER_VERSION env variable
docker_version=$(docker run --rm --entrypoint bash "${image}" -c 'echo "${DOCKER_VERSION}" | cut -d "-" -f 1 | cut -d "~" -f 1')

# Get ubuntu version (with patch)
ubuntu_version=$(docker run --rm --entrypoint bash "${image}" -c "lsb_release -sd |  tr -s ' ' | cut -d ' ' -f 2")

echo "${wrapper_version}_mesos-${mesos_version}_docker-${docker_version}_ubuntu-${ubuntu_version}"
