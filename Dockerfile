FROM mesosphere/mesos-slave:1.0.11.0.1-2.0.93.ubuntu1404
MAINTAINER Mesosphere <support@mesosphere.io>

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qqy \
        apt-transport-https \
        ca-certificates \
        curl \
        lxc \
        iptables \
        ipcalc \
        linux-image-extra-virtual \
        && \
    apt-get clean

# Install specific Docker version
ENV DOCKER_VERSION 1.10.3-0~trusty
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    mkdir -p /etc/apt/sources.list.d && \
    echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge remove docker-engine && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qqy \
        docker-engine=${DOCKER_VERSION} \
        && \
    apt-get clean

ENV WRAPPER_VERSION 0.3.0
COPY ./wrapdocker /usr/local/bin/

ENTRYPOINT ["wrapdocker"]
CMD ["mesos-slave"]
