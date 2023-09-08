###################################
# WRF-Hydro Forcing Engine testing container
# Purpose:
#   Provide pre-built wgrib2, mpi, and ESMF libraries for
#   testing and running the Forcing Engine
###################################

FROM ubuntu:latest 
SHELL ["/bin/bash", "-c"]
USER root

# install build environment
RUN apt-get update \
    && apt-get -y install wget make cmake gcc gfortran pip vim less rsh-client libhdf5-serial-dev libnetcdf-dev

# install mpich
RUN MPICH_VERSION="4.1" \
    && MPICH_CONFIGURE_OPTIONS="" \
    && MPICH_MAKE_OPTIONS='-j 2' \
    && mkdir /tmp/mpich-src \
    && cd /tmp/mpich-src \
    && wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
    && cd mpich-${MPICH_VERSION}  \
    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
    && make ${MPICH_MAKE_OPTIONS} && make install \
    && rm -rf /tmp/mpich-src


# add docker user
RUN mkdir /home/docker \
    && useradd -s /bin/bash -d /home/docker -m docker \
    && chown docker /home/docker

USER docker

# Place MPI libraries into the LD path.
RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
RUN export LIBRARY_PATH=/usr/local/lib
RUN export INCLUDE_PATH=/usr/local/include

# install conda
RUN cd $HOME \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.5.2-0-Linux-x86_64.sh \
    && bash Miniconda3-py310_23.5.2-0-Linux-x86_64.sh -b
    
RUN export PATH=$HOME/miniconda3/bin:$PATH \
    && conda init bash

# install ESMF
RUN mkdir $HOME/.esmf-src \ 
    && cd $HOME/.esmf-src \
    && wget https://github.com/esmf-org/esmf/archive/refs/tags/v8.5.0.tar.gz \
    && tar xfz v8.5.0.tar.gz \
    && ln -s esmf-8.5.0 esmf \
    && cd esmf \
    && export ESMF_DIR=$PWD \
    && export ESMF_COMM=mpich3 \
    && make

USER root

RUN cd /home/docker/.esmf-src/esmf \
    && export ESMF_DIR=$PWD \
    && export ESMF_COMM=mpich3 \
    && make install

RUN pip install mpi4py h5py netcdf4 numpy 

USER docker

COPY bash.rc /home/docker/.bashrc

# install ESMpy
RUN source ~/.bashrc \
    && export ESMFMKFILE=/home/docker/.esmf-src/esmf/DEFAULTINSTALLDIR/lib/libO/Linux.gfortran.64.mpich.default/esmf.mk \
    && cd /home/docker/.esmf-src/esmf/src/addon/esmpy \
    && make install

# install wgrib2
RUN cd $HOME \
    && wget https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v3.1.2 \
    && tar xfz wgrib2.tgz.v3.1.2 \
    && cd grib2 \
    && export CC=gcc \
    && export FC=gfortran \
    && make \
    && make lib

####################################
######### entrypoint ###########
####################################
COPY install_python_packages.sh /home/docker
COPY run_tests.sh /home/docker

CMD ["/bin/bash","-c", "/home/docker/install_python_packages.sh; /home/docker/run_tests.sh"]
