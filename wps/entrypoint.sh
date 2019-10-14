#!/bin/bash



###########################
###No need to edit below here
echo
echo -e "\e[7;49;32mWPS Container - CONUS\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving training materials\e[0m"

git clone https://github.com/NCAR/wrf_hydro_training
mkdir /home/docker/wrf-hydro-training/lessons
cp wrf_hydro_training/lessons/internal/Lesson-wps.ipynb /home/docker/wrf-hydro-training/lessons
rm -rf /home/docker/wrf_hydro_training/

echo "Retrieved the training materials"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Jupyter notebook server running"
echo
echo "Open your browser to the following address to access notebooks"
echo -e "\033[33;5;7mlocalhost:8889\033[0m"
echo
echo -e "The password to login is:"
echo -e "\033[33;5;7mwrfhydrotraining\033[0m"
echo 
echo "Press ctrl-C then type 'y' then press return to shut down container." 
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

jupyter lab --ip 0.0.0.0 --no-browser &> /dev/null

