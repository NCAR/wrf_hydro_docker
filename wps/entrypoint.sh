#!/bin/bash

###Change the (WRF-Hydro) version here
version=v5.1.1-beta
###########################


###########################
###No need to edit below here
echo -e "\e[4;i49;34m WPS Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"

release=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/tags/$version)
exampleCaseURL=$(echo "$release" | grep 'croton_NY_example_testcase' \
| grep "browser_download_url" \
| cut -d : -f 2,3 |  tr -d \")

echo "$exampleCaseURL" | wget -qi -
tar -xf *testcase*.tar.gz
rm *testcase*.tar.gz
mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case

echo "Retrieved the test case for release: $version"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

git clone https://github.com/NCAR/wrf_hydro_training
mkdir /home/docker/wrf-hydro-training/lessons
cp wrf_hydro_training/lessons/internal/Lesson-wps.ipynb /home/docker/wrf-hydro-training/lessons
rm -rf /home/docker/wrf_hydro_training/

echo "Retrieved the WPS lesson

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Jupyter notebook server running"
echo
echo "Open your browser to the following address to access notebooks"
echo -e "\033[33;5;7mlocalhost:8888\033[0m"
echo
echo -e "The password to login is:"
echo -e "\033[33;5;7mwrfhydrotraining\033[0m"
echo 
echo "Press ctrl-C then type 'y' then press return to shut down container." 
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

jupyter lab --ip 0.0.0.0 --no-browser &> /dev/null
