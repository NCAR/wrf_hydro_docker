#!/bin/bash

## This code is common to
## compile_docker.sh
## run_docker.sh ?????????
## interactive_docker.sh

## grab the environment + absolute path to wrf_hydro_tools
## get the path to wrf_hydro_tools
whtPath=`grep "wrf_hydro_tools=" ~/.wrf_hydro_tools | cut -d '=' -f2 | tr -d ' '`
source $whtPath/utilities/sourceMe.sh

## Pass the envrionment
envToPass="$(for i in `henv`; do echo "-e $i";done)"
#envToPass="$envToPass -e LOCAL_USER_ID=`id -u $USER`"
#printf -- "$envToPass"

##directories to mount
if [[ "${1}" == "compile" ]]; then

    topLevWrfHydro=`git rev-parse --show-toplevel 2> /dev/null`
    if [[ -z $topLevWrfHydro ]]; then
	echo "Not in a git repository. Please check your path and try again. Exiting".
	exit 1
    fi
    dirsToMnt="-v ${topLevWrfHydro}:/wrf_hydro -v $whtPath:/wrf_hydro_tools"

else

    ## interactive and run: use working directory
    baseMountDir="/$(basename $(echo `pwd`| rev) | rev)"
    dirsToMnt="-v ${baseMountDir}:${baseMountDir} -v $whtPath:/wrf_hydro_tools"
    
fi

