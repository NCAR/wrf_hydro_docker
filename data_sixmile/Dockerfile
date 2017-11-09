###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.8.17
###################################

FROM wrfhydro/ubuntu

MAINTAINER jamesmcc

####################################
########## ROOT USER  ##############
####################################
USER root

#### CLEAN UP ####
WORKDIR /

COPY 04233300_VM.tar /04233300_VM.tar
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
