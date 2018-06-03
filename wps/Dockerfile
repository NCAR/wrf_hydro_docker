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

############################
###WRF and WPS

#Set WRF and WPS version argument
ARG WRFWPS_VERSION="3.9"

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

RUN rm -r /home/docker/WRF_WPS/WPSV3.9 \
	&& rm -r /home/docker/WRF_WPS/WRFV3.9

RUN chmod -R 777 /home/docker/WRF_WPS

############################
## Python
#Fetch latest miniconda and install
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh

#Set environment variables
ENV PATH="/home/docker/miniconda3/bin:${PATH}"

#Setup virtual environment
RUN conda update conda
RUN conda config --add channels conda-forge --force
#RUN conda create -n docker_conda python=3.6 
#RUN source activate docker_conda

#Install modules
RUN conda install -y cartopy rasterio netcdf4 f90nml xarray
RUN pip install wrf-python Image

############################
# Setup stuff for geogrid script

RUN mkdir -p /home/docker/WRF_WPS/WPS/utilities/ \
	&& mv /home/docker/WRF_WPS/WPS/namelist.wps \
	/home/docker/WRF_WPS/WPS/namelist.wps_orig

COPY make_geogrid.py /home/docker/WRF_WPS/utilities/make_geogrid.py
COPY wrf_hydro_namelist.wps /home/docker/WRF_WPS/utilities/

COPY geog_conus.tar.gz . 
RUN	tar -xf geog_conus.tar.gz && \
	mv geog_conus /home/docker/WRF_WPS/utilities/geog_conus && \
	rm geog_conus.tar.gz

RUN mv /home/docker/WRF_WPS/utilities/geog_conus/GEOGRID.TBL.ARW.wrf_hydro_training \
	/home/docker/WRF_WPS/WPS/geogrid/GEOGRID.TBL.ARW

####################################
########## DOCKER USER #############
####################################
USER docker
WORKDIR /home/docker
#ENV NETCDF=/usr/local

ENTRYPOINT ["python", "/home/docker/WRF_WPS/utilities/make_geogrid.py"]
