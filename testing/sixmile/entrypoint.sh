#!/bin/bash
echo -e "\e[4;49;34m WRF-Hydro Testing Container\e[0m"

theHelp='
The testing container entry point calls NCAR/wrf_hydro_testing scripts. 

Invocation as follows:

The following environment variables are required:
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

docker run -it \
           -e GITHUB_USERNAME=$GITHUB_USERNAME \
           -e GITHUB_AUTHTOKEN=$GITHUB_AUTHTOKEN \
           wrfhydro/testing

## This one should always pass. 
docker run -it \
           -e GITHUB_USERNAME=$GITHUB_USERNAME \
           -e GITHUB_AUTHTOKEN=$GITHUB_AUTHTOKEN \
           -e testFork=NCAR/wrf_hydro_nwm \
           -e referenceFork=NCAR/wrf_hydro_nwm \
           wrfhydro/testing

docker run -it \ 
           -e GITHUB_USERNAME=$GITHUB_USERNAME \
           -e GITHUB_AUTHTOKEN=$GITHUB_AUTHTOKEN \
           -e testFork=NCAR/wrf_hydro_nwm \
           -e testBranchCommit=4612e9c \  
           -e referenceFork=NCAR/wrf_hydro_nwm \
           -e referenceBranchCommit=f2db0b55c5c9dab60646a38f8536001907952767 \
           wrfhydro/testing


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

#if [[ "${1}" == 'interactive' ]]; then exec /bin/bash -l; exit 0; fi

## Do everything in $HOME
cd $HOME

doExit=0
if [[ -z ${GITHUB_USERNAME} ]]; then
    echo "The required environment variable GITHUB_USERNAME has 
           not been passed to the container. Please try 
           'docker run wrfhydro/testing --help' 
           for h     elp. Exiting"
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

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mCloning NCAR/wrf_hydro_tests\e[0m"
git clone https://${authInfo}@github.com/jmccreight/wrf_hydro_tests || \
    { echo Failed to clone repository.; exit 1; }
## JLM FIX REPO/FORK ABOVE

echo 
ls -d $HOME/wrf_hydro_tests > /dev/null 2>&1 || \
    { echo "No such directory: $HOME/wrf_hydro_tests"; exit 1; }

## The environment variables
export WRF_HYDRO_TEST_DIR=`pwd`/wrf_hydro_tests
export REPO_DIR=`pwd`/repos
export domainDir=/test_domain
## For non-docker applications, the domainDir needs cloned.
export testName=CI

## invoke the test
source wrf_hydro_tests/tests/$testName/test.sh

exit $?
