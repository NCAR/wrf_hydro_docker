#!/bin/bash

echo WRF-Hydro Development Docker: "$1" mode

###################################
## setup wrf_hydro_tools
echo "wrf_hydro_tools=/wrf_hydro_tools" > ~/.wrf_hydro_tools
source /wrf_hydro_tools/utilities/sourceMe.sh


###################################
## compile
if [[ "${1}" == 'compile' ]]; then

    ## Work in $HOME
    cd $HOME

    ## JLM: would prefer to work directly in /wrf_hydro which is the git repo on the local
    ##      machine. But I get strage issues, seemingly related to CPP (though not totall sure).
    ##      Source *.F files are modified and deleted in the repo and compilation fails.
    ##      WORKAROUND is to copy all source files to the joedocker user home and 
    
    ## WRF-Hydro source
    ## JLM: I would like to compile in place and NOT copy, but get strange CPP? behavoir even
    ##      using gosu. See docker file gosu section. Is it a permissions issue?
    cp -r /wrf_hydro .
    cd wrf_hydro/trunk/NDHMS
    henv
    ./use_env_compileTag_offline_NoahMP.sh 6
    
    ## Bring a runnable binary back to the host machine.
    ## JLM: WHY does this work of the in-place compilation is a permissions issue?
    lastBin=`ls -rt Run/* | tail -n1`
    chmod 777 $lastBin
    cp -L  $lastBin /wrf_hydro/trunk/NDHMS/Run/.

    ## Cleanup
    rm -rf ~/wrf_hydro ~/.wrf_hydro_tools
    exit $?
    
fi

###################################
## run
if [[ "${1}" == 'run' ]]; then

    ## Work in $HOME
    cd $HOME

    ## WRF-Hydro source
    ## JLM: I would like to compile in place and NOT copy, but get strange CPP? behavoir even
    ##      using gosu. See docker file gosu section. Is it a permissions issue?
    cp -r /wrf_hydro .
    cd wrf_hydro/trunk/NDHMS
    henv
    ./use_env_compileTag_offline_NoahMP.sh 6
    
    ## Bring a runnable binary back to the host machine.
    ## JLM: WHY does this work of the in-place compilation is a permissions issue?
    lastBin=`ls -rt Run/* | tail -n1`
    chmod 777 $lastBin
    cp -L  $lastBin /wrf_hydro/trunk/NDHMS/Run/.

    ## Cleanup
    rm -rf ~/wrf_hydro ~/.wrf_hydro_tools
    exit $?
    
fi

###################################
## interactive
if [[ "${1}" == 'interactive' ]]; then
    
    exec /bin/bash
    exit $?

fi



