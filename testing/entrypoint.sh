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
    echo
    git clone https://${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}@github.com/NCAR/wrf_hydro_tools
    echo
    git clone https://${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}@github.com/NCAR/wrf_hydro_nwm
    
fi

###################################
## circleci
#if [[ "${1}" == 'circleci' ]]; then
#    ## stuff handled in circleci
##fi


###################################
## setup wrf_hydro_tools
echo "wrf_hydro_tools=/home/docker/wrf_hydro_tools" > ~/.wrf_hydro_tools
echo "# Following established in interface.sh entrypoint:" >> ~/.bashrc
echo "source /home/docker/wrf_hydro_tools/utilities/sourceMe.sh" >> ~/.bashrc
echo 'PS1="\[\e[0;49;34m\]\\u@\h[\!]:\[\e[m\]\\w> "' >> ~/.bashrc

cd wrf_hydro_nwm/trunk/NDHMS/
#git checkout gnu_fix

echo
cp ~/wrf_hydro_tools/utilities/use_env_compileTag_offline_NoahMP.sh .

echo
source ~/.bashrc
source /home/docker/wrf_hydro_tools/utilities/sourceMe.sh
setHenv -RLS

echo
./use_env_compileTag_offline_NoahMP.sh 2
theBinary=`pwd`/Run/`ls -rt Run | tail -n1`
cd /home/docker/test.files.frng.nwm/
cp $theBinary .
mpirun -np 2 ./`basename $theBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

exec /bin/bash

exit $?
