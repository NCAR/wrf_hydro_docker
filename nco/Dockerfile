###################################
# Author: Joe Mills <jmills -at- ucar.edu>
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/ubuntu

MAINTAINER jamesmcc@ucar.edu
USER root

####################################
########## ROOT USER  ##############
####################################
RUN apt-get update
RUN apt-get install -yq --no-install-recommends \
    wget \
    ca-certificates \
    libxrender1 \
    libfontconfig1 \
    libxext6 \
    nco \
    ncview \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
