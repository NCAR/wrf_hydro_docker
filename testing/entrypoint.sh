#!/bin/bash


theHelp='
Arguments:
1: mode in [ 'local', 'circleci', '--help' ]

If local,
The following envionrment variables are required:
* GITHUB_USERNAME
* GITHUB_AUTHTOKEN for that user on github (see below for details)
The following environment variables are optional:
[*] testFork,              A named fork on github.         
                           Default = ${GITHUB_USERNAME}/wrf_hydro_nwm
[*] testBranchCommit,      A branch or commit on testFork. 
                           Default = master
[*] referenceFork,         A named fork on github.         
                           Default = NCAR/wrf_hydro_nwm
[*] referenceBranchCommit, A branch or commit on referenceFork. 
                           Default = master   

Example usages: 

docker run -e GITHUB_USERNAME=$GITHUB_USERNAME \
           -e GITHUB_AUTHTOKEN=$GITHUB_AUTHTOKEN \
           wrfhydro/testing local


docker run -e GITHUB_USERNAME=$GITHUB_USERNAME \
           -e GITHUB_AUTHTOKEN=$GITHUB_AUTHTOKEN \
           -e testFork=NCAR/wrf_hydro_nwm \
           -e testBranchCommit=4612e9c \  
           -e referenceFork=NCAR/wrf_hydro_nwm \
           -e referenceBranchCommit=f2db0b55c5c9dab60646a38f8536001907952767 \
           wrfhydro/testing local


Here is a suggestion on how to manage the GITHUB environment variables. 
Configure your ~/.bashrc with the following

export GITHUB_AUTHTOKEN=`cat ~/.github_authtoken 2> /dev/null`
export GITHUB_USERNAME=jmccreight


The file ~/.github_authtoken should be READ-ONLY BY OWNER 500. For example:

jamesmcc@chimayo[736]:~/WRF_Hydro/wrf_hydro_docker/testing> ls -l ~/.github_authtoken 
-r--------  1 jamesmcc  rap  40 Nov  3 10:18 /Users/jamesmcc/.github_authtoken

The file contains the user authtoken from github with no carriage return or other 
whitespace in the file. See 

https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/

for information on getting your github authtoken.

Help on CircleCI usage will be added (though should eb unnecessary.
'

if [[ "${1}" == '--help' ]]; then echo "$theHelp"; exit 0; fi

echo -e "\e[4;49;34m WRF-Hydro Testing Container\e[0m"

## Work in $HOME
cd $HOME

###################################
## local
if [[ "${1}" == 'local' ]]; then

    doExit=0
    if [[ -z ${GITHUB_USERNAME} ]]; then
        echo "The required environment variable GITHUB_USERNAME has 
              not been passed to the container. Please try 
              'docker run wrfhydro/testing --help' 
              for help. Exiting"
        doExit=1
    fi
    if [[ -z ${GITHUB_AUTHTOKEN} ]] ; then
        echo "The required environment variable GITHUB_AUTHTOKEN has 
              not been passed to the container. Please try 
              'docker run wrfhydro/testing --help' 
              for help. Exiting"
        doExit=1
    fi
    if [[ $doExit -eq 1 ]]; then exit 1; fi
    
    authInfo=${GITHUB_USERNAME}:${GITHUB_AUTHTOKEN}
    if [[ -z ${testFork} ]]; then testFork=${GITHUB_USERNAME}/wrf_hydro_nwm; fi
    if [[ -z ${testBranchCommit} ]]; then testBranchCommit=master; fi
    if [[ -z ${referenceFork} ]]; then referenceFork=NCAR/wrf_hydro_nwm; fi
    if [[ -z ${referenceBranchCommit} ]]; then referenceBranchCommit=master; fi
    
    echo
    echo -e "\e[0;49;32m-----------------------------------\e[0m"
    echo -e "\e[7;49;32mCloning testing dependencies\e[0m"
    git clone https://${authInfo}@github.com/jmccreight/ncoScripts

    echo
    git clone https://${authInfo}@github.com/NCAR/wrf_hydro_tools
   
    echo
    # test fork
    echo -e "\e[0;49;32m-----------------------------------\e[0m"
    echo -e "\e[7;49;32mTest fork: $testFork\e[0m"
    git clone https://${authInfo}@github.com/$testFork
    mv `basename $testFork` wrf_hydro_test
    cd wrf_hydro_test
    git checkout $testBranchCommit || \
        { echo "Unsuccessful checkout of $testBranchCommit from $testFork."; exit 1; }
    echo -e "\e[0;49;32mRepo moved to\e[0m `pwd`"
    echo -e "\e[0;49;32mTest branch:\e[0m    `git branch`"
    echo -e "\e[0;49;32mTesting commit:\e[0m"
    git log -n1
    cd ..
    
    echo
    # reference fork
    echo -e "\e[0;49;32m-----------------------------------\e[0m"
    echo -e "\e[7;49;32mReference fork: $referenceFork\e[0m"
    git clone https://${authInfo}@github.com/$referenceFork    
    cd `basename $referenceFork`
    git checkout $referenceBranchCommit || \
        { echo "Unsuccessful checkout of $referenceBranchCommit from $referenceFork."; exit 1; }
    echo -e "\e[0;49;32mRepo in\e[0m `pwd`"
    echo -e "\e[0;49;32mReference branch:\e[0m    `git branch`"
    echo -e "\e[0;49;32mReference commit:\e[0m"
    git log -n1
    cd ..
    
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
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mCompiling the new binary.\e[0m"

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
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRunning run.1.new\e[0m"

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
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mCompiling the reference (old) code\e[0m"

cd /root/wrf_hydro_nwm/trunk/NDHMS/
echo
cp /root/wrf_hydro_tools/utilities/use_env_compileTag_offline_NoahMP.sh .

## 2 is gfort  >>>> FRAGILE <<<<
./use_env_compileTag_offline_NoahMP.sh 2 || { echo "Compilation failed."; exit 3; }
theRefBinary=`pwd`/Run/`ls -rt Run | tail -n1`

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRunning run.2.old\e[0m"

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
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mComparing the results.\e[0m"
source /comp_nco.sh
comp_nco run.2.old run.1.new

###################################
## Run 3: perfect restarts
echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRunning run.3.restart_new\e[0m"

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
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mComparing the results.\e[0m"
comp_nco run.1.new run.3.restart_new


###################################
## Run 4: ncores test
echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRunning run.4.ncores_new\e[0m"

cd /root/sixmile_docker_tests/run.4.ncores_new
cp $theBinary .
nCoresTest=3
mpirun -np $nCoresTest ./`basename $theBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

cd ../
echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mComparing the results.\e[0m"
comp_nco run.1.new run.4.ncores_new

#exec /bin/bash

echo "Success. All tests appear successful. "

exec /bin/bash

exit $?
