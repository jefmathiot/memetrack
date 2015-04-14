FROM ruby:2.2.1

# Inspired by https://github.com/jpetazzo/dind
MAINTAINER Jef Mathiot <jef@nonblocking.info>

# Install Docker
ENV DOCKER_VERSION=1.5.0
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
RUN apt-get update && apt-get install -qqy \
  lxc-docker=$DOCKER_VERSION apparmor

# Install Docker-Compose
ENV COMPOSE_VERSION 1.1.0
ADD https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-Linux-x86_64 /usr/local/bin/docker-compose

# Install PhantomJS (required by Cucumber/Poltergeist)
ENV PHANTOMJS_PKG phantomjs-1.9.8-linux-x86_64
ADD https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS_PKG.tar.bz2 /tmp/$PHANTOMJS_PKG.tar.bz2
RUN cd /tmp && tar xjf /tmp/$PHANTOMJS_PKG.tar.bz2 && mv $PHANTOMJS_PKG/bin/phantomjs /usr/local/bin

WORKDIR /memetrack

# Watch for updates in the dependencies
COPY integration/Gemfile* /memetrack/integration/

# Install Cucumber's dependencies
RUN bundle install --gemfile=/memetrack/integration/Gemfile

# Docker in Docker wrapper
ADD ./dockerfiles/ci/wrapdocker /usr/local/bin/wrapdocker

# Continuous Integration suite
ADD ./dockerfiles/ci/ci-run.sh /usr/local/bin/ci-run

RUN chmod +x \
  /usr/local/bin/wrapdocker \
  /usr/local/bin/docker-compose \
  /usr/local/bin/ci-run

VOLUME ["/var/lib/docker:/var/lib/docker"]

ENTRYPOINT ["wrapdocker"]
