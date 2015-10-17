#!/usr/bin/env bash

# Prints the repo version to be used for the Docker image tag

image=${1:-}
[ -z "${image}" ] && echo "No image supplied" && exit 1


# TODO: replace with version dynamically generated based on git tags & dirty state
# docker run --rm "${image}"
# $(mesos-slave --version)
echo "0.2.1_mesos-0.23.0_docker-1.8.2_ubuntu-14.04.3"
