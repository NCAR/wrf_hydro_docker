###################################
# Author: Joe Mills <jmills -at- ucar.edu>
#         James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/nco

MAINTAINER jamesmcc
USER root

####################################
########## ROOT USER  ##############

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