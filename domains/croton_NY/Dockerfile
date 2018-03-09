FROM alpine:latest
MAINTAINER Joe Mills <jmills@ucar.edu>
COPY domain/ /home/docker/domain/croton_NY
RUN chmod -R 777 /home/docker/domain/croton_NY

#FROM scratch
#COPY --from=0 --chown=docker /home/docker/domain/croton_NY /home/docker/domain/croton_NY
VOLUME /home/docker/domain/croton_NY

ENTRYPOINT ["dummy/entry/point"]
