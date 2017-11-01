#!/bin/bash

# Purpose: Run WRF-Hydro using MPI in a docker container in-place on host.
#          
# Arguments:
#    1: number of processors/cores, required.
#    2: the binary, required.
#    3: the name of the docker container image (optional, default=wrf_hydro_dev)
#
# Note: standard error and standard out are both teed, so they appear in terminal and
#       on file, to wrf_hydro.stdout and wrf_hydro.stderr, respectively.
#
# Usage:
# ./run_docker.sh 4 wrf_hydro.exe [some_other_image]

# Default image is wrf_hydro_dev
image=${3-wrf_hydro_dev}

# JLM: how do we know where this script is?
whDockerPath=`grep "wrf_hydro_docker=" ~/.wrf_hydro_tools | cut -d '=' -f2 | tr -d ' '` 
if [[ -z $whDockerPath ]]; then
    echo "Warning wrf_hydro_docker path is not specified in ~/.wrf_hydro_tools"
else
    if [[ ! -d $whDockerPath ]]; then
	echo "Warning: wrf_hydro_docker path ($whDockerPath) does not exist."
    fi
fi
source $whDockerPath/development/prelude_to_docker_run.sh || exit 1

# pass the environment and the working dir to 
docker run -it ${envToPass} ${dirsToMnt} $image run `pwd` $1 $2


exit 0
