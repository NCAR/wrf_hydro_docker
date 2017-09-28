#!/bin/bash

## Purpose: Facilitate various modes of docker interaction with WRF-Hydro models.
##          Establish the 
##            1) desired docker image
##            1) WRF_Hydro environment variables
##            2) wrf_hydro_tools repo
##          to a subsequent script which makes a more detailed call.
## Arguments:
##   1) the name of the docker container image (optional, default=wrf_hydro_dev)
## Dependencies:
##   wrf_hydro_tools repository installed locally. 
## Usage:
## ./compile_docker.sh [some_other_image]

## Default image is wrf_hydro_dev
image=${1-wrf_hydro_dev}

## grab the environment + absolute path to wrf_hydro_tools
## get the path to wrf_hydro_tools
whtPath=`grep "wrf_hydro_tools=" ~/.wrf_hydro_tools | cut -d '=' -f2 | tr -d ' '`
source $whtPath/utilities/sourceMe.sh

## Pass the envrionment
envToPass="$(for i in `henv`; do echo "-e $i";done)"
#envToPass="$envToPass -e LOCAL_USER_ID=`id -u $USER`"
#printf -- "$envToPass"

##directories to mount
topLevWrfHydro=$(dirname $(dirname `pwd`))
dirsToMnt="-v ${topLevWrfHydro}:/wrf_hydro -v $whtPath:/wrf_hydro_tools"

## pass the environment and the working dir to 
docker run -t ${envToPass} ${dirsToMnt} $image compile
## JLM: support make/compileTag?
## multithreaded make?

exit 0
