#!/bin/bash

# Purpose:
#          
# Arguments:
#  1) commit?
#  2) docker image
# Note: 
#
# Usage:
# 

# Default image is wrf_hydro_testing
image=${1-wrfhydro/testing}


docker run -it \
       -e GITHUB_AUTHTOKEN=$GITHUB_AUTHTOKEN \
       -e GITHUB_USERNAME=$GITHUB_USERNAME \
       $image local


exit 0
