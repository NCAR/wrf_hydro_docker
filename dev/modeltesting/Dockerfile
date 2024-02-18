###################################
# WRF-Hydro testing container
# Purpose:
#   Given a candidate and optionally a reference code repository, execute
#   wrf_hydro_nwm_public tests
# The above is achieved through entrypoint and host-side scripting.
#
# Authors: Joe Mills
# Email:  jmills-at-ucar.edu
# Date:  2018-07-25
###################################

FROM wrfhydro/dev:base

###################################
### Python installations ##########
###################################

#Install modules
# RUN pip install --upgrade pip
RUN pip install wrfhydropy>=0.0.21 gdown matplotlib importlib-metadata pytest pytest-datadir-ng numpy netCDF4

####################################
######### entrypoint ###########
####################################
COPY run_tests_docker.py /home/docker
COPY entrypoint.sh /home/docker

ENTRYPOINT ["/home/docker/entrypoint.sh"]
