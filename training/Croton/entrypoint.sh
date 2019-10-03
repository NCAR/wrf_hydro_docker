#!/bin/bash

###Change the versions here
version=v5.1.1
release=v5.1.1-beta
training_branch=master
###########################


###########################
###No need to edit below here
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving latest community model code release\e[0m"

release_json=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/tags/$release)
git clone --branch $version https://github.com/NCAR/wrf_hydro_nwm_public
mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public

echo "Retrieved the following version: $version"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"

exampleCaseURL=$(echo "$release_json" | grep 'croton_NY_example_testcase' \
| grep "browser_download_url" \
| cut -d : -f 2,3 |  tr -d \")

curl -L $exampleCaseURL | tar xzC /home/docker/wrf-hydro-training/

echo "Retrieved the test case for release: $release"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

git clone --branch ${training_branch} https://github.com/NCAR/wrf_hydro_training
mv /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons
rm -rf /home/docker/wrf_hydro_training/

echo "Retrieved the following training: ${training_branch}"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Training Jupyter notebook server running"
echo
echo "Open your browser to the following address to access notebooks"
echo -e "\033[92;7mhttp://localhost:8888\033[0m"
echo
echo -e "The password to login is:"
echo -e "\033[92;7mwrfhydrotraining\033[0m"
echo 
echo "Press ctrl-C then type 'y' then press return to shut down container." 
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

jupyter lab --ip 0.0.0.0 --no-browser &> /dev/null
