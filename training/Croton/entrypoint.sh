#!/bin/bash

###Change the versions here
code_branch=v5.2.x
training_branch=master
###########################


###########################
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving model code\e[0m"

git clone --branch ${code_branch} https://github.com/NCAR/wrf_hydro_nwm_public
mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public

echo "Retrieved the model code"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"

gdown https://drive.google.com/uc?id=1_Ivc02C1WWkZcuBaSl9YePrqQE5osiCp

echo "Retrieved the test case"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

git clone --branch ${training_branch} https://github.com/NCAR/wrf_hydro_training
mv /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons
rm -rf /home/docker/wrf_hydro_training/

echo "Retrieved the training"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving the GIS training\e[0m"

git clone https://github.com/mcasali/GIS_Training

echo "Retrieved the GIS training"

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
