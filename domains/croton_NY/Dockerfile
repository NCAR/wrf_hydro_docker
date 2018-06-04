FROM alpine:3.7
MAINTAINER Joe Mills <jmills@ucar.edu>
USER root

# Get domain from google drive
## Get download script
COPY gdrive_dl_docker.sh /gdrive_dl_docker.sh
RUN chmod 777 gdrive_dl_docker.sh

RUN /bin/sh gdrive_dl_docker.sh 1EHgWeM8k2-Y3jNMLri6C0u_fIUQIonO_ croton_NY.tar.gz && \
	mkdir -p /home/docker/domain && \
	tar -xf croton_NY.tar.gz && \
	mv example_case /home/docker/domain/croton_NY

RUN chmod -R 777 /home/docker/domain/croton_NY

VOLUME /home/docker/domain/croton_NY

