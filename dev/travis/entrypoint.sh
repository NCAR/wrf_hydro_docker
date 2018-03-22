#!/bin/bash

#Arguments:
#1: The domain directory
#2: candidate source code directory
#3: reference source code directory
#4: test ouput directory if mounting to local disk for test data persistence 

#Notes: GITHUB_USERNAME and GITHUB_AUTHTOKEN environment variables 
#		need to be passed in for github authentication

echo -e "\e[4;49;34m WRF-Hydro Travis-CI Docker\e[0m"

DOMAIN_DIR=$1
CANDIDATE_SOURCE_DIR=$2
REFERENCE_SOURCE_DIR=$3
TEST_OUT_DIR=$4

#Clone the testing repo
echo -e "\e[7;49;1mCloning testing repo\e[0m" 
git clone https://github.com/NCAR/wrf_hydro_py.git /home/docker/wrf_hydro_py 2> /dev/null

#Run the fundamental test
echo -e "\e[7;49;1mRunning Tests\e[0m" 
python3 /home/docker/wrf_hydro_py/wrfhydro/travis_fundamental.py $DOMAIN_DIR $CANDIDATE_SOURCE_DIR $REFERENCE_SOURCE_DIR /home/docker/fundamental_test_out

#Get test exit code
fundamental_ret=$?

if [[ $fundamental_ret == 0 ]]; then
	echo -e "\e[5;49;32mTest passed!\e[0m" 
else
	echo -e "\e[5;49;31mTest failed.\e[0m" 
fi

#Copy to mounted drive
echo -e "\e[7;49;1mCleanup\e[0m" 
if [[ ! -z $TEST_OUT_DIR ]]; then
	cp -P -r /home/docker/fundamental_test_out $TEST_OUT_DIR 2> /dev/null
fi

#EXit with 1 if test failed
if [[ $fundamental_ret == 0 ]]; then
	exit 0
else
	exit 1
fi
