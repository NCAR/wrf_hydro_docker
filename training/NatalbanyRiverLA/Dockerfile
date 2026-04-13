FROM wrfhydro/dev:latest
USER docker

COPY ./entrypoint.sh /.
WORKDIR /home/docker
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
