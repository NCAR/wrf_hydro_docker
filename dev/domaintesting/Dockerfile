###################################
# Image name: wrfhydro/domaintesting:c5_2_0
# Author: Kevin Sampson <ksampson@ucar.edu>
# Date:  2023-12-04
###################################
FROM wrfhydro/dev:base

MAINTAINER ksampson@ucar.edu
USER root

############################
#Get the entrypoint script to download the code release
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

USER docker
WORKDIR /home/docker

############################
RUN /entrypoint.sh

############################
#Copy local setEnvar.sh script and compile WRF-Hydro using compile option 2
COPY ./setEnvar.sh /home/docker/wrf_hydro_nwm_public/trunk/NDHMS
RUN cd ./wrf_hydro_nwm_public/trunk/NDHMS && ./configure 2 && ./compile_offline_NoahMP.sh setEnvar.sh
WORKDIR /home/docker