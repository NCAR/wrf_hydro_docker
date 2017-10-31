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

    ## if compiling, need
    ## 1) the full wrf_hydro repo directory
    ## 2) wrf_hydro_tools

    ## 1
    topLevWrfHydro=`git rev-parse --show-toplevel 2> /dev/null`
    if [[ -z $topLevWrfHydro ]]; then
	echo "Not in a git repository. Please check your path and try again. Exiting".
	exit 1
    fi
    ## 1+2
    dirsToMnt="-v ${topLevWrfHydro}:/wrf_hydro -v $whtPath:/wrf_hydro_tools"

else

    ## interactive and run: use working directory
    baseMountDir="/$(basename $(echo `pwd`| rev) | rev)"
    dirsToMnt="-v ${baseMountDir}:${baseMountDir}"
    #echo "dirsToMnt: $dirsToMnt"
    
    ## osx additions
    if [[ $OSTYPE == *"darwin"* ]] ; then
        if [[ $baseMountDir == "/User" ]] ; then
            ## append this to get users' home available
            dirsToMnt="-v /Users/`whoami`:/Users/`whoami`"
            echo "dirsToMnt: $dirsToMnt"
        else
            ## if /Users, restrict it to the user making the request.
            dirsToMnt="$dirsToMnt -v /Users/`whoami`:/Users/`whoami`"
        fi
    fi
    
    ## wrf_hydro_tools in /wrf_hydro_tools
    dirsToMnt="$dirsToMnt -v $whtPath:/wrf_hydro_tools"

    #echo "dirsToMnt: $dirsToMnt"    
fi

