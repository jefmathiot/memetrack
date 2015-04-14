FROM ubuntu:trusty
MAINTAINER Jef Mathiot <jef@nonblocking.info>

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -qqy \
  nginx-extras

# Allow environment variables (Docker links)
RUN sed -i -e \
  "1ienv APP_PORT_3000_TCP_ADDR;\nenv APP_PORT_3000_TCP_PORT;" \
  /etc/nginx/nginx.conf

# Disable daemon mode
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Add server configuration
ADD memetrack.conf /etc/nginx/sites-enabled/default

ENTRYPOINT ["nginx"]
