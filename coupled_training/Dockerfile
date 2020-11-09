########################################
# WRF-Hydro Coupled Training Dockerfile
# Author: Katelyn FitzGerald
# Date:   2020-11-03
########################################


FROM ubuntu:focal

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    bc\
    bzip2 \
    ca-certificates \
    csh \
    curl \
    file \
    g++ \
    gfortran \
    git \
    less \
    libcurl4-gnutls-dev \
    libhdf5-dev \
    libnetcdf-dev \
    libnetcdff-dev \
    libopenmpi-dev \
    libpng-dev \
    libswitch-perl \
    libssl-dev \
    libxml2-dev \
    locales \
    m4 \
    make \
    nano \
    netcdf-bin \
    openmpi-bin \
    openssh-client \
    tcsh \
    valgrind \ 
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/* 

RUN locale-gen en_US.UTF-8    

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

## NetCDF installs

# Install netCDF-C
ENV LIB_DIR=/usr/local
ENV HDF5_DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial

RUN NETCDF_C_VERSION="4.4.1.1" \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_C_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/netcdf-${NETCDF_C_VERSION}.tar.gz -C /tmp \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && CPPFLAGS=-I${HDF5_DIR}/include LDFLAGS=-L${HDF5_DIR}/lib ./configure --prefix=${LIB_DIR} \
    && make \
    && make install \
    && rm -rf /tmp/netcdf* 
    

# Install netCDF-Fortran
ENV LD_LIBRARY_PATH=${LIB_DIR}/lib
RUN NETCDF_F_VERSION="4.4.4" \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${NETCDF_F_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/netcdf-fortran-${NETCDF_F_VERSION}.tar.gz -C /tmp \
    && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION} \
    && CPPFLAGS=-I${LIB_DIR}/include LDFLAGS=-L${LIB_DIR}/lib ./configure --prefix=${LIB_DIR} \
    && make \
    && make install \
    && rm -rf /tmp/netcdf*

# Install jasper to support grib2
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz -P /tmp \
    && tar -xf /tmp/jasper*tar.gz -C /tmp \
    && cd /tmp/jasper* \
    && ./configure --prefix=${LIB_DIR} \
    && make \
    && make install \
    && rm -rf /tmp/jasper* 
    
#################################
## Create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker
RUN chmod -R 777 /home/docker/
#################################

## WRF and WPS installs

#Set WRF and WPS version argument
ARG WRF_VERSION="4.2.1"
ARG WPS_VERSION="4.2"

#Set WRF-Hydro version argument
ARG HYDRO_VERSION="5.1.2"

WORKDIR /home/docker/WRF_WPS

RUN wget https://github.com/wrf-model/WRF/archive/v${WRF_VERSION}.tar.gz \
        && tar -zxf v${WRF_VERSION}.tar.gz \
        && mv WRF-${WRF_VERSION} WRF \
        && rm v${WRF_VERSION}.tar.gz

RUN wget https://github.com/NCAR/wrf_hydro_nwm_public/archive/v${HYDRO_VERSION}.tar.gz \
        && tar -zxf v${HYDRO_VERSION}.tar.gz \
        && rm -r WRF/hydro \
        && cp -r wrf_hydro_nwm_public*/trunk/NDHMS WRF/hydro \
        && rm v${HYDRO_VERSION}.tar.gz

RUN wget https://github.com/wrf-model/WPS/archive/v${WPS_VERSION}.tar.gz \
	&& tar -zxf v${WPS_VERSION}.tar.gz \
        && mv WPS-${WPS_VERSION} WPS \
	&& rm v${WPS_VERSION}.tar.gz

# Set paths to required libraries
ENV NETCDF=/usr/local
ENV JASPERLIB=/usr/lib
ENV JASPERINC=/usr/include

# Set WRF-Hydro environment variables
ENV WRF_HYDRO=1
ENV HYDRO_D=1
ENV SPATIAL_SOIL=0
ENV WRF_HYDRO_RAPID=0
ENV WRFIO_NCD_LARGE_FILE_SUPPORT=1
ENV WRF_HYDRO_NUDGING=0

# Build WRF first, required for WPS
WORKDIR /home/docker/WRF_WPS/WRF
RUN printf '34\n1\n' | ./configure \
        && ./compile em_real  

# Build WPS second after WRF is built
WORKDIR /home/docker/WRF_WPS/WPS
RUN printf '1\n' | ./configure \
        && ./compile 

RUN chmod -R 777 /home/docker/WRF_WPS

## Python installs
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh

#Set environment variables
ENV PATH="/home/docker/miniconda3/bin:${PATH}"

WORKDIR /home/docker

RUN conda install -c conda-forge \
    nodejs \
    gdal \
    nco \
    nccmp \
    numpy \
    cython \
    jupyterlab \
    jupyter_contrib_nbextensions \
    ipython \
    h5py \
    mpi4py \
    netcdf4 \
    esmpy \
    matplotlib \
    dask \
    toolz \
    xrviz \
    xarray \
    gdown 

RUN conda install -c pyviz hvplot

RUN jupyter labextension install @jupyterlab/toc @pyviz/jupyterlab_pyviz 

RUN pip install bash_kernel \
        && python -m bash_kernel.install

#################################
RUN mkdir /home/docker/wrf-hydro-training \
        && chmod -R 777 /home/docker/wrf-hydro-training 

#################################
#Get the Jupyter configuration script
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

#################################
#Get the entrypoint script to download the code, example case, and lessons and start JupyterLab
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh
RUN chmod -R 777 /home/docker/wrf-hydro-training/
RUN chmod -R 777 /home/docker/WRF_WPS/

USER docker
WORKDIR /home/docker

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
