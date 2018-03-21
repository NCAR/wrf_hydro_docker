#!/bin/bash

theHelp="
## Purpose: Pass the native OS environment variables and
##          the working directory to a docker for compile.
## Arguments:
##   1) the name of the docker container image (optional, default=wrfhydro/dev:base)
## Dependencies:
##   wrf_hydro_tools repository installed locally. 
## Usage:
## ./interactive_docker.sh [some_other_image]
"

if [[ $1 == '--help' ]]; then
    echo "$theHelp"
    exit 0
fi

## Default image is wrfhydro/dev:base
image=${1-wrfhydro/dev:base}

## JLM:how do we know where this script is?
whDockerPath=`grep "wrf_hydro_docker=" ~/.wrf_hydro_tools | cut -d '=' -f2 | tr -d ' '` 
if [[ -z $whDockerPath ]]; then
    echo "Warning wrf_hydro_docker path is not specified in ~/.wrf_hydro_tools"
else
    if [[ ! -d $whDockerPath ]]; then
	echo "Warning: wrf_hydro_docker path ($whDockerPath) does not exist."
    fi
fi
source $whDockerPath/dev/scripts/prelude_to_docker_run.sh || exit 1

## pass the environment and the working dir to 
docker run -it ${envToPass} ${dirsToMnt} $image interactive `pwd`

exit 0
