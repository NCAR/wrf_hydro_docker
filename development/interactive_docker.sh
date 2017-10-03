#!/bin/bash

## Purpose: Pass the native OS environment variables and
##          the working directory to a docker for compile.
## Arguments:
##   1) the name of the docker container image (optional, default=wrf_hydro_dev)
## Dependencies:
##   wrf_hydro_tools repository installed locally. 
## Usage:
## ./compile_docker.sh [some_other_image]

## Default image is wrf_hydro_dev
image=${1-wrf_hydro_dev}

## JLM:how do we know where this script is?
whDockerPath=`grep "wrf_hydro_docker=" ~/.wrf_hydro_tools | cut -d '=' -f2 | tr -d ' '` 
if [[ -z $whDockerPath ]]; then
    echo "Warning wrf_hydro_docker path is not specified in ~/.wrf_hydro_tools"
else
    if [[ ! -d $whDockerPath ]]; then
	echo "Warning: wrf_hydro_docker path ($whDockerPath) does not exist."
    fi
fi
source $whDockerPath/development/prelude_to_docker_run.sh || exit 1

## pass the environment and the working dir to 
docker run -it ${envToPass} ${dirsToMnt} $image interactive `pwd`

exit 0
