###################################
# Image name: wrfhydro/hawaii-training
# Author: Katelyn FitzGerald <katelynw@ucar.edu>
# Date:  2020-11-02
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
    valgrind \ 
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/* 

RUN locale-gen en_US.UTF-8    

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

#################################
## Create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker
RUN chmod -R 777 /home/docker/
#################################

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

USER docker
WORKDIR /home/docker

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
