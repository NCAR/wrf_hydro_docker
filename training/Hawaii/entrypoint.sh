#!/bin/bash

###Change the versions here
code_branch=v5.2.x
training_branch=Hawaii_Training
###########################


###########################
###No need to edit below here
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving the model code\e[0m"

git clone --branch ${code_branch} https://github.com/NCAR/wrf_hydro_nwm_public
mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public

echo "Retrieved the following code: $version"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

git clone --branch ${training_branch} https://github.com/NCAR/wrf_hydro_training
mv /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons
rm -rf /home/docker/wrf_hydro_training/

echo "Retrieved the following training: ${training_branch}"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro example case\e[0m"

gdown https://drive.google.com/uc?id=1FZNWLTmAkO7WnaPji9CSmYqYFPfY52Gf
tar -xzvf oahu*.tar.gz
rm oahu*.tar.gz
mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case

echo "Retrieved the WRF-Hydro example case"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Training JupyterLab server running"
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
