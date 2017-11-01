###################################
# Author: Tony Castronova <acastronova -at- cuahsi.org>
# Author: Joe Mills <jmills -at- ucar.edu>
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM ubuntu:16.04

MAINTAINER jamesmcc@ucar.edu
USER root

####################################
########## ROOT USER  ##############
####################################
#Get all library dependencies for NCL, wrf_hydro, and mpich
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
    && rm -rf /var/lib/apt/lists/*

# install NCL
# That's ugly, not sure why they dont just put the version in the filename.
ARG NCL_LOCATION="https://www.earthsystemgrid.org/download/"
# Both of the following will likely need updated with version
ARG NCL_FILENAME="fileDownload.html?logicalFileId=154af009-fa02-11e6-a976-00c0f03d5b7c"
ARG NCL_VERSION="6.4.0"
RUN wget ${NCL_LOCATION}${NCL_FILENAME} \
  && mkdir /usr/local/ncl-${NCL_VERSION} \
  && tar -xzf ${NCL_FILENAME} -C /usr/local/ncl-${NCL_VERSION} \
  && rm ${NCL_FILENAME}