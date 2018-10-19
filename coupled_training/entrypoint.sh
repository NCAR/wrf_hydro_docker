#!/bin/bash

###Change the version here
version=v5.0.2
###########################


###########################
###No need to edit below here
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving coupled test case domain files\e[0m"

release=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/tags/$version)
coupledCaseURL=$(echo "$release" | grep 'coupled' \
| grep "browser_download_url" \
| cut -d : -f 2,3 |  tr -d \")

echo "$coupledCaseURL" | wget -qi -
tar -xf *coupled*.tar.gz
rm *coupled*.tar.gz
#chmod -R 777 ~/example_case
mv /home/docker/frontrange_coupled_domain_files /home/docker/wrf-hydro-training

echo "Retrieved the coupled test case for release: $version"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

git clone --branch ${version: 0:4}.x https://github.com/NCAR/wrf_hydro_training
mkdir /home/docker/wrf-hydro-training/lessons
mv /home/docker/wrf_hydro_training/lessons/Lesson-S3-coupled.ipynb /home/docker/wrf-hydro-training/lessons/Lesson-S3-coupled.ipynb
rm -rf /home/docker/wrf_hydro_training/

echo "Retrieved the following coupled training: ${version: 0:4}.x"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Training Jupyter notebook server running"
echo
echo "Open your browser to the following address to access notebooks"
echo -e "\033[33;5;7mlocalhost:8484\033[0m"
echo
echo -e "The password to login is:"
echo -e "\033[33;5;7mwrfhydrotraining\033[0m"
echo 
echo "Press ctrl-C then type 'y' then press return to shut down container." 
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

jupyter notebook --ip 0.0.0.0 --no-browser &> /dev/null
