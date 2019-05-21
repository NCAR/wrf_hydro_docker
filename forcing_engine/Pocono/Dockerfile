#############################################
# Image name: wrfhydro/nwm-training:v2.0
# Author: Logan Karsten <karsten@ucar.edu>
# Date: 2019-05-02
#############################################

FROM wrfhydro/dev:base as build

MAINTAINER karsten@ucar.edu
USER root

RUN mkdir /home/docker/wrf-hydro-training && chown docker:docker /home/docker/wrf-hydro-training

# Install necessary Python libraries
RUN pip install mpi4py h5py netcdf4 numpy gdown jupyterlab jupyter_contrib_nbextensions

# Place MPI libraries into the LD path.
RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
RUN export LIBRARY_PATH=/usr/local/lib
RUN export INCLUDE_PATH=/usr/local/include

# Download and install ESMF built against the 
# wrfhydro/dev MPICH
RUN mkdir /home/docker/.esmf-src \
    && cd /home/docker/.esmf-src \
    && wget http://www.earthsystemmodeling.org/esmf_releases/public/ESMF_7_1_0r/esmf_7_1_0r_src.tar.gz \
    && tar xfz esmf_7_1_0r_src.tar.gz \
    && cd esmf \
    && export ESMF_DIR=$PWD \
    && export ESMF_COMM=mpich3 \
    && make \
    && make install

# Install the Python ESMPy API to ESMF
RUN cd /home/docker/.esmf-src/esmf/src/addon/ESMPy \
    && python setup.py build --ESMFMKFILE=/home/docker/.esmf-src/esmf/DEFAULTINSTALLDIR/lib/libO/Linux.gfortran.64.mpich3.default/esmf.mk install

# Download and install wgrib2
RUN cd /home/docker \
    && wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz \
    && tar xfz wgrib2.tgz \
    && rm wgrib2.tgz \
    && cd /home/docker/grib2 \
    && export CC=gcc \
    && export FC=gfortran \
    && make \
    && make lib

ENV PATH=/home/docker/wgrib2:${PATH}

## SWITCH TO USER "DOCKER"

USER docker
WORKDIR /home/docker

# Set the proper environmental paths
RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PATH=/home/docker/grib2/wgrib2:${PATH}

RUN mkdir /home/docker/wrf-hydro-training/forcing_engine

# Download the test-case data, including input forcing GRIB2 files
# and input domain files used for the forcing engine. 
RUN cd /home/docker/wrf-hydro-training/forcing_engine \
    && gdown https://drive.google.com/uc?id=1CvcNPNBa5vjbFR3lNbWwsfdnTy62RuIa \
    && tar -xf RFC_Training2019_FE.tar \
    && rm RFC_Training2019_FE.tar 

# Download the training repo.
RUN cd /home/docker \
     && git clone --single-branch --branch RFC_Training https://github.com/NCAR/wrf_hydro_training \
     && mv /home/docker/wrf_hydro_training/lessons/forcing_engine /home/docker/wrf-hydro-training/lessons \
     && rm -rf /home/docker/wrf_hydro_training/

# Download the WRF-Hydro forcing engine code.
RUN cd /home/docker/wrf-hydro-training/forcing_engine/Pocono_Forcing \
    && git clone https://github.com/logankarsten/WrfHydroForcing

FROM wrfhydro/dev:base

USER docker
WORKDIR /home/docker

ENV PATH=/home/docker/grib2/wgrib2:${PATH}

COPY --from=build --chown=docker:docker /home/docker /home/docker
COPY --chown=docker:docker ./entrypoint.sh /.
COPY --chown=docker:docker ./jupyter_notebook_config.py /home/docker/.jupyter/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
