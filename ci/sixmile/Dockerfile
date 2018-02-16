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

RUN mkdir /home/docker/repos

#Grab domain from previous domain layer
COPY --from=domain /home/docker/domain/sixmile_NY /home/docker/domain

#set permissions
RUN chmod -R 777 /home/docker/domain
RUN chmod -R 777 /home/docker/repos

#set user back to docker
USER docker