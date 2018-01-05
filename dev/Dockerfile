###################################
# WRF-Hydro Development docker
# Purpose:
#   1) Compile code on the host system (non-interactive mode)
#   2) Run code on the host system     (non-interactive mode)
#   3) Interactive use. 
# The above is achieved through entrypoint and host-side scripting.
#
# Authors: Tony Castronova, James McCreight, Joe Mills
# Email:  acastronova-at-cuahsi.org, jamesmcc-at-ucar.edu, jmills-at-ucar.edu
# Date:  8.29.2017, 9.15.2017, 10.1.2017, 11.1.2017
###################################

FROM wrfhydro/gcc_default
#AS builder

#FROM wrfhydro/nco
#COPY --from=builder / /
## JLM: I dont understand the failure of libmpi.so.12
## JLM: `ldd wrf_hydro...exe` only implies the following. 
##COPY --from=builder /usr /usr
##COPY --from=builder /lib/x86_64-linux-gnu/ /lib/x86_64-linux-gnu/
## this fails miserably now...

MAINTAINER jamesmcc

###################################
## build nco and nccmp here. really not what I was hpoing for.
#Get NCCMP to compare netcdf files
RUN add-apt-repository ppa:remik-ziemlinski/nccmp && \
        apt-get update && \
        apt-get install -yq --no-install-recommends \
	nco \
	nccmp \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*
	
###################################
## wrf-hydro development docker interface script
COPY ./interface.sh /.

###################################
## create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker

####################################
######### docker user ###########
####################################
USER docker
ENV NETCDF=/usr/local
RUN cp /interface.sh ~/.
RUN cd $HOME
ENTRYPOINT ["/interface.sh"]
CMD ["interactive"]