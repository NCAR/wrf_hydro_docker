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
MAINTAINER jmills@ucar.edu

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
RUN pip install pytest pytest-datadir-ng wrfhydropy==0.0.5.dev1

####################################
######### entrypoint ###########
####################################
RUN mkdir /home/docker/entrypoint
COPY *.py /home/docker/entrypoint/
ENTRYPOINT ["python", "/home/docker/entrypoint/run_tests.py"]