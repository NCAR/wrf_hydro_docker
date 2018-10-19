###################################
# Author: Joe Mills <jmills@ucar.edu>
# Date:  10.15.2017
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
ARG WRFWPS_VERSION="4.0.1"

#Set WRF-Hydro version argument
ARG HYDRO_VERSION="4.0.2"

#Install coupled WRF | WRF-Hydro AND WPS
WORKDIR /home/docker/WRF_WPS
#
# Download sources for version specified by WRFWPS_VERSION argument
#
RUN wget https://github.com/wrf-model/WRF/archive/v${WRFWPS_VERSION}.tar.gz \
	&& tar -zxf v${WRFWPS_VERSION}.tar.gz \
        && mv WRF-${WRFWPS_VERSION} WRF \
	&& rm v${WRFWPS_VERSION}.tar.gz
RUN wget https://github.com/NCAR/wrf_hydro_nwm_public/archive/v${HYDRO_VERSION}.tar.gz \
        && tar -zxf v${HYDRO_VERSION}.tar.gz \
        && rm -r WRF/hydro \
        && mv wrf_hydro_nwm_public*/trunk/NDHMS WRF/hydro \
        && rm v${HYDRO_VERSION}.tar.gz
RUN wget https://github.com/wrf-model/WPS/archive/$v{WRFWPS_VERSION}.tar.gz \
	&& tar -zxf v${WRFWPS_VERSION}.tar.gz \
        && mv WPS-${WRFWPS_VERSION} WPS \
	&& rm v${WRFWPS_VERSION}.tar.gz

# Set WRF-Hydro environment variables
ENV WRF_HYDRO=1
ENV HYDRO_D=0
ENV SPATIAL_SOIL=0
ENV WRF_HYDRO_RAPID=0
ENV WRFIO_NCD_LARGE_FILE_SUPPORT=1
ENV NCEP_WCOSS=0
ENV WRF_HYDRO_NUDGING=0

# Build WRF first, required for WPS
WORKDIR /home/docker/WRF_WPS/WRF
RUN printf '34\n1' | ./configure \
	&& ./compile em_real

# Build WPS second after WRF is built
WORKDIR /home/docker/WRF_WPS/WPS
RUN printf '1' | ./configure \
	&& ./compile

RUN chmod -R 777 /home/docker/WRF_WPS

############################
## Python
WORKDIR /

#Fetch latest miniconda and install
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh

#Set environment variables
ENV PATH="/home/docker/miniconda3/bin:${PATH}"

#Setup virtual environment
RUN conda update conda
RUN conda config --add channels conda-forge --force

#Install modules
RUN conda install -y cartopy rasterio netcdf4 f90nml xarray
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
