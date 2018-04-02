###################################
# Author: Joe Mills <jmills@ucar.edu>
# Date:  9.27.2017
###################################
#
# This Dockerfile compiles WRF and WPS from source using the bare-bones requirements for training purposes.
# See https://ral.ucar.edu/projects/ncar-docker-wrf for more complete WRF and WPS docker builds with additional functionality

FROM wrfhydro/dev:base

MAINTAINER jmills@ucar.edu
USER root

#Set WRF and WPS version argument
ARG WRFWPS_VERSION="3.9"

#################
#Install WRF AND WPS
WORKDIR /home/docker/WRF_WPS
#
# Download sources for version specified by WRFWPS_VERSION argument
#
RUN wget http://www2.mmm.ucar.edu/wrf/src/WRFV${WRFWPS_VERSION}.TAR.gz \
	&& \
	mkdir WRFV${WRFWPS_VERSION} \
	&& tar -zxf WRFV${WRFWPS_VERSION}.TAR.gz \
	&& rm WRFV${WRFWPS_VERSION}.TAR.gz
RUN wget http://www2.mmm.ucar.edu/wrf/src/WPSV${WRFWPS_VERSION}.TAR.gz \
	&& mkdir WPSV${WRFWPS_VERSION} \
	&& tar -zxf WPSV${WRFWPS_VERSION}.TAR.gz \
	&& rm WPSV${WRFWPS_VERSION}.TAR.gz

# Build WRF first, required for WPS
WORKDIR /home/docker/WRF_WPS/WRFV3
RUN printf '32\n0' | ./configure \
	&& ./compile em_real

# Build WPS second after WRF is built
WORKDIR /home/docker/WRF_WPS/WPS
RUN printf '1' | ./configure \
	&& ./compile geogrid

####################################
########## CUAHSI USER #############
####################################
USER docker
WORKDIR /home/docker

