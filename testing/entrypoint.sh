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
echo "tmpPath=/glade/scratch/jamesmcc/jlmTmp" > /root/.ncoScripts
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


allOldFinalFiles=`ls *201306020000* *2013-06-02_00:00*`

cd ../

echo
echo "------------------------------------"
echo "Comparing the results."


for ff in $allOldFinalFiles; do

    echo
    echo -^-^-^-^-^-^-^-^-^-^-^-
    echo "$ff file comparison"
    ncdiff -O run.1.new/$ff \
              run.2.old/$ff  diff.nc || { echo "New file run.1.new/$ff is missing." ; exit 5; }
    
    
    ## This is super ad-hoc >>>> FRAGILE <<<<
    theVars=`ncVarList diff.nc`
    for vv in $theVars; do
        theResult=`ncVarRng $vv diff.nc`
        #echo $theResult
        tmp=`echo $theResult | cut -d'(' -f2- | tr -d '\n' | sed 's/[^0-9]*//g' | egrep [1-9]  `
        anyNonZeros=`echo $tmp | wc -w`
        if [[ $anyNonZeros -ne 0 ]]; then
            echo "The result was not zero for variable $vv"
            echo $theResult
        fi   
    done
    
done

exec /bin/bash


echo "Success. All tests appear successful. "

exec /bin/bash

exit $?
