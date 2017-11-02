###################################
# WRF-Hydro Development docker
# Purpose:
#   1) Compile code on the host system (non-interactive mode)
#   2) Run code on the host system     (non-interactive mode)
#   3) Interactive use. 
# The above is achieved through entrypoint and host-side scripting.
#
# Authors: Tony Castronova, James McCreight, Joe Mills
# Email:  acastronova@cuahsi.org, jamesmcc@ucar.edu, jmills@ucar.edu
# Date:  8.29.2017, 9.15.2017, 10.1.2017, 11.1.2017
###################################

FROM wrfhydro/gcc_5.4.0
FROM wrfhydro/nc_tools

MAINTAINER jamesmcc@ucar.edu

###################################
## create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker
ENV NETCDF=/usr/local

###################################
## wrf-hydro development docker interface script
COPY ./interface.sh /.

####################################
######### docker user ###########
####################################
USER docker
RUN cp /interface.sh ~/.
RUN cd $HOME
ENTRYPOINT ["/interface.sh"]
CMD ["interactive"]