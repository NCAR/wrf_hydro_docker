###################################
# WRF-Hydro Development docker
# Purpose:
#   Encapsulate the tools required for testing WRF-Hydro
# Authors: James McCreight, Joe Mills
# Email:  jamesmcc-at-ucar.edu, jmills@-at-car.edu
# Date:  11.2.2017
###################################

FROM wrfhydro/dev 

MAINTAINER jamesmcc

###################################
USER root

RUN apt-get install -yq --no-install-recommends software-properties-common \
    && apt-add-repository universe \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
    python
    
WORKDIR /root

###################################
## wrf-hydro development docker interface script
COPY ./entrypoint.sh /.
COPY ./gnu.txt /.

###################################
## create docker user
#RUN rm -rf /home/docker
#RUN useradd -ms /bin/bash docker
#RUN usermod -aG sudo docker

###################################
# DATA for test.
# Eventually, have a service that will pull data on the fly.
COPY sixmile_docker_tests.tar .
RUN  tar xf sixmile_docker_tests.tar
#COPY test.files.frng.nwm test.files.frng.nwm
#RUN chmod -R 777 /home/docker/test.files.frng.nwm

###################################
#USER docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]