FROM wrfhydro/dev:conda
user root
MAINTAINER jmills@ucar.edu
COPY ./entrypoint.sh /home/docker/
RUN chmod 777 /home/docker/entrypoint.sh
####################################
######### docker user ###########
####################################
USER docker
WORKDIR /home/docker
ENTRYPOINT ["/home/docker/entrypoint.sh"]
#CMD ["interactive"]