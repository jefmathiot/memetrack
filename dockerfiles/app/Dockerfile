FROM ruby:2.2.1
MAINTAINER Jef Mathiot <jef@nonblocking.info>

# System dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -qqy \
  imagemagick

# Speed up installation of RubyGems (no doc, parallel installs)
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN mkdir ~/.bundle ; echo -e '---\nBUNDLE_JOBS: 6' > ~/.bundle/config

WORKDIR /memetrack

# Watch for updates in the dependencies
COPY Gemfile* /memetrack/

# Install the dependencies
RUN bundle install

# The app will bind to this port
EXPOSE 3000
