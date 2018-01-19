# Mesos Slave Docker-in-Docker (dind)

Mesos-Slave that runs in a Ubuntu-based Docker container.

Launches tasks using the included Docker Engine, rather than the host's Docker Engine.

## Features

- Runs Mesos tasks inside the container (instead of in the parent Docker env).
- Mesos tasks (in docker containers) are stopped when the mesos-slave-dind container is stopped.
- Supports OverlayFS (new hotness) and AUFS (legacy)
  - Allocates disk space (via loop mount) to allow mounting AUFS on AUFS
- Allocates IP space on the parent Docker's network, making docker-in-docker containers IP accessible from the host.

## Networking

There are two networking mode options: default & bridged.

By default, the inner docker daemon gets its own network. These inner container IPs will not be accessible by the host.

Bridged networking mode can be enabled by populating `DOCKER_NETWORK_OFFSET` (env var). In bridged networking mode, containers launched by the inner docker daemon will be given IPs on the host docker network. This requires reserving a range of IPs on the host docker network for each mesos-slave-dind container by specifying an offset (`DOCKER_NETWORK_OFFSET`) and a size (`DOCKER_NETWORK_SIZE`). The offset should be specific to the container, and the range (offset <-> offset + size - 1) should not overlap with other reserved ranges.

## Required Docker Parameters

- `--privileged=true` - Provides access to cgroups

## Recommended Environment Variables

- **MESOS_CONTAINERIZERS** - Include docker to enable running tasks as docker containers. Ex: `docker,mesos`
- **MESOS_RESOURCES** - Specify resources to avoid oversubscribing via auto-detecting host resources. Ex: `cpus:4;mem:1280;disk:25600;ports:[21000-21099]`
- **DOCKER_NETWORK_OFFSET** - Specify an IP offset to give each mesos-slave-dind container (enables bridged network mode). Ex: `0.0.1.0` (slave A), `0.0.2.0` (slave B)
- **DOCKER_NETWORK_SIZE** - Specify a CIDR range to apply to the above offset (default=`24`).
- **VAR_LIB_DOCKER_SIZE** - Specify the max size (in GB) of the loop device to be mounted at /var/lib/docker (default=`5`). This is only used if OverlayFS is not supported by the kernel or the parent docker is configured to use AUFS.

Source: <https://github.com/mesosphere/mesos-slave-dind>

Inspiration: <https://github.com/jpetazzo/dind>

## License

Copyright 2015-2018 [The Mesos Slave Docker-in-Docker Authors](./AUTHORS.md)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
