#!/bin/bash

###Change the versions here
version_short=v5.4
version_full=${version_short}.0
training_branch=lsu_training_2026
###########################

###########################
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"
echo

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

set -e -x
git clone --depth 1 --branch ${training_branch} https://github.com/NCAR/wrf_hydro_training wrf-hydro-training
set +e +x
echo "Retrieved the training"


echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mChecking out WRF-Hydro ${version_full} branch\e[0m"

git -C /home/docker/wrf_hydro_nwm_public -c advice.detachedHead=false checkout ${version_full}
mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public
echo "Checkout out model code ${version_full}"


echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"

set -e -x
wget -nv https://github.com/NCAR/wrf_hydro_training/releases/download/v5.1.x/natalbany_River_LA_example.tar.gz
{ set +x; } 2>/dev/null
tar -zxf natalbany_River_LA_example.tar.gz
mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case
rm *_example.tar.gz
echo "Retrieved the testcase"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Training Jupyter notebook server running"
echo
echo "Open your browser to the following address to access notebooks"
echo -e "\033[92;7mhttp://localhost:8888\033[0m"
echo
echo "Press ctrl-C then type 'y' then press return to shut down container."
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

set -e
exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' &> /dev/null
