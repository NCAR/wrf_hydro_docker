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
WORKDIR /root

###################################
## wrf-hydro development docker interface script
COPY ./entrypoint.sh /.
COPY ./gnu.txt /.
COPY ./comp_nco.sh /.

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

###################################
# wrf_hydro_nwm repo
# circleCI: cheked out by .circleci/config.yml
# local   : entrypoint checks out the code 
# JLM: how to give it specific commit?

###################################
# wrf_hydro_tools repo
# circleCI: cheked out by .circleci/config.yml
# local   : entrypoint checks out the code
# JLM: how to give it a specific commit?


ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]