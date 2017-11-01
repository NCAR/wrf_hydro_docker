#!/bin/bash

#Arguments:
#1: mode
#2: working directory. required for run mode.
#3: number of processors/cores. required for run mode.
#4: the binary. required for run mode.

echo -e "\e[4;49;34m WRF-Hydro Development Docker: $1 mode \e[0m"

###################################
## setup wrf_hydro_tools
echo "wrf_hydro_tools=/wrf_hydro_tools" > ~/.wrf_hydro_tools
echo "# Following established in interface.sh entrypoint:" >> ~/.bashrc
echo "source /wrf_hydro_tools/utilities/sourceMe.sh" >> ~/.bashrc
echo 'PS1="\[\e[0;49;34m\]\\u@\h[\!]:\[\e[m\]\\w> "' >> ~/.bashrc

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
    if [[ $? -eq 0 ]]; then
        lastBin=`ls -rt Run/* | tail -n1`
        chmod 777 $lastBin
        cp -L  $lastBin /wrf_hydro/trunk/NDHMS/Run/.
    else
        echo 'Compilation not successful'
        exit 1
    fi
        
    ## Cleanup
    ## rm -rf ~/wrf_hydro ~/.wrf_hydro_tools
    exit $?
    
fi

###################################
## run
if [[ "${1}" == 'run' ]]; then

    workDir=$2
    nCores=$3
    theBin=$4
    
    if [[ -z $workDir ]]; then
	echo "Working directory not specified as the second argument for run mode, exiting."
	exit 1
    fi

    if [[ -z $nCores ]]; then
	echo "Number of processors/cores not specified as second argument to run_docker, exiting."
	exit 1
    fi

    if [[ -z $theBin ]]; then
	echo "The binary was not specified as third argument to run_docker, exiting."
	exit 1
    fi

    # change the working dir or dy trying
    cd $workDir || \
	{ echo "Cannot switch to working dir ($workDir) on docker, exiting."; exit 1; }
    
    ## enforce the number of processors?

    ## enforce existence of the binary file
    if [[ ! -e $theBin ]]; then
	echo "The binary speficied (${theBin}) does not exist."
	exit 1 
    fi
    
    mpiexec -n $nCores ./${theBin} > >(tee -a wrf_hydro.stdout) 2> >(tee -a wrf_hydro.stderr >&2)
    
    exit $?
    
fi

###################################
## interactive
if [[ "${1}" == 'interactive' ]]; then
    
    if [[ ! -z $2 ]]; then cd $2; fi

    ## OSX: The mounting is setup to only include the requesting user from /Users/`whoami`
    ##      Under other systems, this will fail silently (no way to detect HOST system?).
    cp /Users/*/.wrf_hydro_tools ~/. > /dev/null 2>&1
    
    exec /bin/bash

    #exec "$@"
    exit $?

fi
