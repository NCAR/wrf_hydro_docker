#!/bin/bash

###Change the versions here
code_version=v5.2.0-rc1
training_branch=CUAHSI_Pocono_Training
###########################


###########################
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving model code\e[0m"

wget https://github.com/NCAR/wrf_hydro_nwm_public/archive/${code_version}.tar.gz
tar -xzvf ${code_version}.tar.gz
rm ${code_version}.tar.gz
mv /home/docker/wrf_hydro_nwm_public* /home/docker/wrf-hydro-training/wrf_hydro_nwm_public

echo "Retrieved the model code"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"
gdown https://drive.google.com/uc?id=1Fg555Xf63UZtaT1R9spUP2P5hQm9laSa

tar -xzvf pocono_example_case.tar.gz
rm pocono_example_case.tar.gz
mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case

echo "Retrieved the test case"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

git clone --branch ${training_branch} https://github.com/NCAR/wrf_hydro_training
mv /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons
rm -rf /home/docker/wrf_hydro_training/

git clone https://github.com/NCAR/WrfHydroForcing.git
mv /home/docker/WrfHydroForcing /home/docker/wrf-hydro-training/WrfHydroForcing

git clone https://github.com/NCAR/wrf_hydro_model_tools.git
mv /home/docker/wrf_hydro_model_tools /home/docker/wrf-hydro-training/wrf_hydro_model_tools

gdown https://drive.google.com/uc?id=10Q-0eVakrVmFwZ27ftDDtsSHsg0YBQAT
mkdir /home/docker/wrf-hydro-training/regridding
mv nldas*.tar.gz /home/docker/wrf-hydro-training/regridding/nldas_mfe_forcing.tar.gz

gdown https://drive.google.com/uc?id=1X71fdaSEJ5GWyNY2MDIy9cC6E7A0kihl 
tar -xzvf geog_conus.tar.gz
rm geog_conus.tar.gz
mv /home/docker/geog_conus /home/docker/WRF_WPS/geog_conus

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
