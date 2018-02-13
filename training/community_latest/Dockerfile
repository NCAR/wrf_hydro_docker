###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-02-05
###################################
FROM wrfhydro/domains:croton as domain
FROM wrfhydro/dev

MAINTAINER jmills@ucar.edu
USER root

#Get the script to download the code release
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

COPY --from=domain /home/docker/domain/Croton_NY_0137462010 /home/docker/domain/Croton_NY_0137462010
RUN chmod -R 777 /home/docker/domain/Croton_NY_0137462010

USER docker
WORKDIR /home/docker

COPY ./introTutorial.sh /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]