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

#Install modules
RUN pip install netCDF4 pytest pytest-datadir-ng wrfhydropy==0.0.11

####################################
######### entrypoint ###########
####################################
COPY run_tests_docker.py /home/docker
COPY entrypoint.sh /home/docker

ENTRYPOINT ["/home/docker/entrypoint.sh"]
