###################################
# WRF-Hydro testing container
# Purpose:
#   Given a candidate and optionally a reference code repository, execute 
#   wrf_hydro_nwm_public tests
# The above is achieved through entrypoint and host-side scripting.
#
# Authors: James McCreight
# Email:  jamesmcc-at-ucar.edu
# Date:  2018-10-02
###################################

FROM wrfhydro/dev:base

###################################
### Python installations ##########
###################################
RUN rm -rf runTimeScripts
RUN mkdir build_temp && cd build_temp
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh 

#Set environment variables
ENV PATH="/home/docker/miniconda3/bin:${PATH}"

#Install modules
RUN pip install netCDF4 pytest pytest-datadir-ng wrfhydropy==0.0.11

####################################
######### entrypoint ###########
####################################
COPY run_tests_docker.py /home/docker
COPY entrypoint.sh /home/docker

ENTRYPOINT ["/home/docker/entrypoint.sh"]
