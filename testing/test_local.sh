#!/bin/bash

# Purpose:
#          
# Arguments:
#
# Note: 
#
# Usage:
# 

# Default image is wrf_hydro_dev
#image=${3-wrfhydro/testing}

# JLM: how do we know where this script is?
whDockerPath=`grep "wrf_hydro_docker=" ~/.wrf_hydro_tools | cut -d '=' -f2 | tr -d ' '` 
if [[ -z $whDockerPath ]]; then
    echo "Warning wrf_hydro_docker path is not specified in ~/.wrf_hydro_tools"
else
    if [[ ! -d $whDockerPath ]]; then
	echo "Warning: wrf_hydro_docker path ($whDockerPath) does not exist."
    fi
fi
source $whDockerPath/dev/prelude_to_docker_run.sh || exit 1

# pass the environment and the working dir to 
docker run -it ${envToPass} ${dirsToMnt} $image run `pwd` $1 $2


exit 0
