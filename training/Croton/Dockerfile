###################################
# WRF-Hydro Training Dockerfile
# Author: Katelyn FitzGerald
# Date:   2020-10-28
###################################


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
    r-base-core \
    tcsh \
    texlive-xetex \
    texlive-plain-generic \
    texlive-fonts-recommended \
    valgrind \ 
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/* 

RUN locale-gen en_US.UTF-8    

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

## NetCDF installs

# Install netCDF-C
ENV NCDIR=/usr/local
ENV NFDIR=/usr/local
ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV HDF5_DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial

RUN NETCDF_C_VERSION="4.4.1.1" \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_C_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/netcdf-${NETCDF_C_VERSION}.tar.gz -C /tmp \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && CPPFLAGS=-I${H5DIR}/include LDFLAGS=-L${H5DIR}/lib ./configure --prefix=/usr/local \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && make \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && make install \
    && rm -rf /tmp/netcdf-${NETCDF_C_VERSION}

# Install netCDF-Fortran
ENV LD_LIBRARY_PATH=${NCDIR}/lib
RUN NETCDF_F_VERSION="4.4.4" \
    && cd /tmp \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${NETCDF_F_VERSION}.tar.gz \
    && tar -xf netcdf-fortran-${NETCDF_F_VERSION}.tar.gz \
    && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION} \
    && CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR} \
    && make \
    && make install \
    && cd / \
    && rm -rf /tmp/netcdf-fortran-${NETCDF_F_VERSION}

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

WORKDIR /home/docker/WRF_WPS

RUN wget https://github.com/wrf-model/WRF/archive/v${WRF_VERSION}.tar.gz \
        && tar -zxf v${WRF_VERSION}.tar.gz \
        && mv WRF-${WRF_VERSION} WRF \
        && rm v${WRF_VERSION}.tar.gz
RUN wget https://github.com/wrf-model/WPS/archive/v${WPS_VERSION}.tar.gz \
	&& tar -zxf v${WPS_VERSION}.tar.gz \
        && mv WPS-${WPS_VERSION} WPS \
	&& rm v${WPS_VERSION}.tar.gz

# Set paths to required libraries
ENV NETCDF=/usr/local

# Build WRF first, required for WPS
WORKDIR /home/docker/WRF_WPS/WRF
RUN printf '34\n1\n' | ./configure \
	&& ./compile em_real  

# Build WPS second after WRF is built
WORKDIR /home/docker/WRF_WPS/WPS
RUN printf '2\n' | ./configure \
	&& ./compile 

RUN chmod -R 777 /home/docker/WRF_WPS

# Now delete WRF to save space
RUN rm -rf /home/docker/WRF_WPS/WRF

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
    pyproj \
    rasterio \
    geopandas \
    ipyleaflet \
    ipympl \
    ipywidgets \
    whitebox=1.2.0 \
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

RUN jupyter labextension install @jupyterlab/toc @pyviz/jupyterlab_pyviz @jupyter-widgets/jupyterlab-manager jupyter-leaflet

RUN pip install bash_kernel \
        && python -m bash_kernel.install

## R installs
RUN wget http://cirrus.ucsd.edu/~pierce/ncdf/ncdf4_1.13.tar.gz \
        && R CMD INSTALL ncdf4_1.13.tar.gz  \
        && rm ncdf4_1.13.tar.gz \
        && Rscript -e 'install.packages(c("optparse","stringr","plyr"), repos="https://cran.rstudio.com")' 

#################################
#RUN gdown https://drive.google.com/uc?id=1X71fdaSEJ5GWyNY2MDIy9cC6E7A0kihl \
#        && tar -xzvf geog_conus.tar.gz \
#        && mkdir /home/docker/WRF_WPS/utilities \
#        && mv geog_conus /home/docker/WRF_WPS/utilities \
#	&& rm geog_conus.tar.gz

#################################
RUN mkdir /home/docker/wrf-hydro-training \
        && chmod -R 777 /home/docker/wrf-hydro-training \
        && mkdir /home/docker/GIS_Training \
        && chmod -R 777 /home/docker/GIS_Training

#################################
#Get the Jupyter configuration script
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

#################################
#Get the entrypoint script to download the code, example case, and lessons and start JupyterLab
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh
RUN chmod -R 777 /home/docker/wrf-hydro-training/
RUN chmod -R 777 /home/docker/GIS_Training/
RUN chmod -R 777 /home/docker/miniconda3/
RUN chmod -R 777 /home/docker/WRF_WPS/

USER docker
WORKDIR /home/docker

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
