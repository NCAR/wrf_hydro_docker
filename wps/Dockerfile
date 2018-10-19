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
WORKDIR /home/docker

#Install modules
RUN conda install -c conda-forge -y numpy cartopy rasterio netcdf4 f90nml xarray
RUN pip install wrf-python Image

############################
# Setup stuff for geogrid script
COPY ./namelist.wps_orig /home/docker/WRF_WPS/utilities/namelist.wps_orig

RUN mkdir -p /home/docker/WRF_WPS/WPS/utilities/ \
	&& mv /home/docker/WRF_WPS/WPS/namelist.wps \
	/home/docker/WRF_WPS/WPS/namelist.wps_orig

COPY make_geogrid.py /home/docker/WRF_WPS/utilities/make_geogrid.py
COPY wrf_hydro_namelist.wps /home/docker/WRF_WPS/utilities/

# Get geog data from google drive
## Get download script
COPY gdrive_download.py gdrive_download.py
RUN chmod 777 gdrive_download.py

RUN python gdrive_download.py --file_id 1EICBJ8-pRpkox27Bnq3mrBAqyZQsV662 --dest_file geog_conus.tar.gz \
	&& tar -xf geog_conus.tar.gz \
	&& mv geog_conus /home/docker/WRF_WPS/utilities/geog_conus \
	&& rm geog_conus.tar.gz

RUN chmod -R 777 /home/docker/WRF_WPS/utilities/geog_conus
RUN rm gdrive_download.py

####################################
########## DOCKER USER #############
####################################
USER docker
WORKDIR /home/docker

RUN mkdir /home/docker/tmp/ \
	&& chmod 777 -R /home/docker/tmp/

ENTRYPOINT ["python", "/home/docker/WRF_WPS/utilities/make_geogrid.py"]