#!/bin/bash

#Arguments:
#1: mode in [ 'local', 'circleci' ]
## ? commit of choice? how to get that to circle? need to get that to circle


echo -e "\e[4;49;34m WRF-Hydro Testing Container\e[0m"

## Work in $HOME
cd $HOME

###################################
## local
if [[ "${1}" == 'local' ]]; then

    # If local, then the envionrment variables are required
    # 1) HOST_USERNAME
    # 2) GITHUB_AUTHTOKEN for that user on github
    git clone https://${HOSTUSERNAME}:${GITHUB_AUTHTOKEN}/NCAR/wrf_hydro_tools.git
    git clone https://${HOSTUSERNAME}:${GITHUB_AUTHTOKEN}/NCAR/wrf_hydro_nwm.git
    
fi

###################################
## circleci
if [[ "${1}" == 'circleci' ]]; then
    ## stuff handled in circleci
fi


###################################
## setup wrf_hydro_tools
echo "wrf_hydro_tools=wrf_hydro_tools" > ~/.wrf_hydro_tools
echo "# Following established in interface.sh entrypoint:" >> ~/.bashrc
echo "source /wrf_hydro_tools/utilities/sourceMe.sh" >> ~/.bashrc
echo 'PS1="\[\e[0;49;34m\]\\u@\h[\!]:\[\e[m\]\\w> "' >> ~/.bashrc

exec /bin/bash
exit $?
