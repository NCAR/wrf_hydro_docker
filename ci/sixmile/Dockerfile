###################################
# WRF-Hydro Development docker
# Purpose:
#   Encapsulate the tools required for testing WRF-Hydro
# Authors: Joe Mills, James McCreight
# Email:  jmills-at-ucar.edu, jamesmcc-at-ucar.edu 
# Date:  2017-12-11
###################################
#Get the domain
FROM wrfhydro/domains:sixmile as domain
#Get the environment
FROM wrfhydro/dev
USER root

#Get all scripts and tests from local directory
RUN mkdir wrf_hydro_ci
#COPY . wrf_hydro_ci/	

#Make directory to hold repos

#Grab domain from previous domain layer
COPY --from=domain /test_domain wrf_hydro_ci/test_domain

#Get NCCMP to compare netcdf files
RUN add-apt-repository ppa:remik-ziemlinski/nccmp && \
		apt-get update && \
		apt-get install nccmp

#Move the domain into the testing folder
#RUN mv test_domain $HOME/wrf_hydro_ci

#Set workign directory
WORKDIR wrf_hydro_ci