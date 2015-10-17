#!/usr/bin/env bash

# Prints the image version to be used for the Docker image tag

image=${1:-}
[ -z "${image}" ] && echo "No image supplied" && exit 1

# Get image version
wrapper_version=$(docker run --rm --entrypoint bash "${image}" -c 'echo ${WRAPPER_VERSION}')

# Get mesos-slave version
mesos_version=$(docker run --rm --entrypoint bash "${image}" -c "mesos-slave --version | tr -s ' ' | cut -d ' ' -f 2")

# Get docker client version. Installed server version will match client.
# Docker command contacts server, even tho we're only requsting the client version.
# So mount the socket to avoid an error.
docker_version=$(docker run --rm --entrypoint bash -v /var/run/docker.sock:/var/run/docker.sock "${image}" -c "docker version --format '{{.Client.Version}}'")

# Get ubuntu version (with patch)
ubuntu_version=$(docker run --rm --entrypoint bash "${image}" -c "lsb_release -sd |  tr -s ' ' | cut -d ' ' -f 2")

echo "${wrapper_version}_mesos-${mesos_version}_docker-${docker_version}_ubuntu-${ubuntu_version}"
