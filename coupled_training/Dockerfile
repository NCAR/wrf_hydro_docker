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

RUN rm -rf /home/docker/runTimeScripts

############################
###WRF and WPS

#Set WRF and WPS version argument
ARG WRFWPS_VERSION="4.0.1"

#Set WRF-Hydro version argument
ARG HYDRO_VERSION="5.0.2"

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
RUN wget https://github.com/wrf-model/WPS/archive/v${WRFWPS_VERSION}.tar.gz \
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
WORKDIR /home/docker

#Install modules
RUN conda install -c conda-forge -y jupyterlab jupyter_contrib_nbextensions ipython hdf5 netcdf4 xarray

#Get jupyter config
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

############################
# Get geog data from google drive
## Get download script
COPY gdrive_download.py gdrive_download.py
RUN chmod 777 gdrive_download.py

RUN python gdrive_download.py --file_id 1EICBJ8-pRpkox27Bnq3mrBAqyZQsV662 --dest_file geog_conus.tar.gz \
	&& tar -xf geog_conus.tar.gz \
	&& rm geog_conus.tar.gz
RUN chmod -R 777 /home/docker/geog_conus
RUN rm gdrive_download.py

####################################
########## DOCKER USER #############
####################################
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

RUN mkdir /home/docker/wrf-hydro-training/ && chmod -R 777 /home/docker/wrf-hydro-training/

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]