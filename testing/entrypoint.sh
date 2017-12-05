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
    git clone https://${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}@github.com/jmccreight/ncoScripts

    echo
    git clone https://${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}@github.com/NCAR/wrf_hydro_tools

    echo
    git clone https://${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}@github.com/${GITHUB_USERNAME}/wrf_hydro_nwm
    mv wrf_hydro_nwm wrf_hydro_test

    echo
    git clone https://${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}@github.com/NCAR/wrf_hydro_nwm
    
fi

###################################
## circleci
#if [[ "${1}" == 'circleci' ]]; then
#    ## stuff handled in circleci
##fi


###################################
## setup ncoScripts & wrf_hydro_tools
mkdir /root/ncoTmp
echo "tmpPath=/root/ncoTmp" > /root/.ncoScripts
source /root/ncoScripts/ncFilters.sh

echo "wrf_hydro_tools=/root/wrf_hydro_tools" > /root/.wrf_hydro_tools
echo "# Following established in interface.sh entrypoint:" >> /root/.bashrc
echo "source /root/wrf_hydro_tools/utilities/sourceMe.sh" >> /root/.bashrc
echo 'PS1="\[\e[0;49;34m\]\\u@\h[\!]:\[\e[m\]\\w> "' >> /root/.bashrc
## CD to the testing repo
source /root/.bashrc
source /root/wrf_hydro_tools/utilities/sourceMe.sh
setHenv -RNLS

###################################
## COMPILE
echo
echo "-----------------------------------"
echo "Compiling the new binary."

cd /root/wrf_hydro_test/trunk/NDHMS/
echo
cp /root/wrf_hydro_tools/utilities/use_env_compileTag_offline_NoahMP.sh .

## 2 is gfort  >>>> FRAGILE <<<<
./use_env_compileTag_offline_NoahMP.sh 2 || { echo "Compilation failed."; exit 1; }
echo -e "\e[5;49;32mCompilation successful under GNU!\e[0m"
source /gnu.txt
sleep 2
theBinary=`pwd`/Run/`ls -rt Run | tail -n1`

###################################
## Run 1
echo
echo "------------------------------------"
echo "Running run.1.new"

cd /root/sixmile_docker_tests/run.1.new
cp $theBinary .
nCoresFull=2
mpirun -np $nCoresFull ./`basename $theBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

## did the model finish successfully?
## This grep is >>>> FRAGILE <<<<. But fortran return codes are un reliable. 
nSuccess=`grep 'The model finished successfully.......' diag_hydro.* | wc -l`
if [[ $nSuccess -ne $nCoresFull ]]; then
    echo Run run.1.new failed.
    exit 2
fi

###################################
## Run 2:
## THis requires compiling the old binary, which in theory is not an issue. 
echo
echo '-----------------------------------'
echo "Compiling the reference (old) code"

cd /root/wrf_hydro_nwm/trunk/NDHMS/
echo
cp /root/wrf_hydro_tools/utilities/use_env_compileTag_offline_NoahMP.sh .

## 2 is gfort  >>>> FRAGILE <<<<
./use_env_compileTag_offline_NoahMP.sh 2 || { echo "Compilation failed."; exit 3; }
theRefBinary=`pwd`/Run/`ls -rt Run | tail -n1`

echo
echo "------------------------------------"
echo "Running run.2.old"

cd /root/sixmile_docker_tests/run.2.old
cp $theRefBinary .
nCoresFull=2
mpirun -np $nCoresFull ./`basename $theRefBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

## did the model finish successfully?
## This grep is >>>> FRAGILE <<<<. But fortran return codes are un reliable. 
nSuccess=`grep 'The model finished successfully.......' diag_hydro.* | wc -l`
if [[ $nSuccess -ne $nCoresFull ]]; then
    echo Run run.2.old failed.
    exit 4
fi

cd ../

echo
echo "------------------------------------"
echo "Comparing the results."
source /comp_nco.sh
comp_nco run.2.old run.1.new

###################################
## Run 3: perfect restarts
echo
echo "------------------------------------"
echo "Running run.3.restart_new"

cd /root/sixmile_docker_tests/run.3.restart_new
cp $theBinary .
nCoresFull=2
mpirun -np $nCoresFull ./`basename $theBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

## did the model finish successfully?
## This grep is >>>> FRAGILE <<<<. But fortran return codes are un reliable. 
nSuccess=`grep 'The model finished successfully.......' diag_hydro.* | wc -l`
if [[ $nSuccess -ne $nCoresFull ]]; then
    echo Run run.1.new failed.
    exit 2
fi

cd ../
echo
echo "------------------------------------"
echo "Comparing the results."
comp_nco run.1.new run.3.restart_new


###################################
## Run 4: ncores test
echo
echo "------------------------------------"
echo "Running run.4.ncores_new"

cd /root/sixmile_docker_tests/run.4.ncores_new
cp $theBinary .
nCoresTest=3
mpirun -np $nCoresTest ./`basename $theBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

cd ../
echo
echo "------------------------------------"
echo "Comparing the results."
comp_nco run.1.new run.4.ncores_new



exec /bin/bash


echo "Success. All tests appear successful. "

exec /bin/bash

exit $?
