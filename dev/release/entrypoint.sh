#!/bin/bash

###Change the version here
version=v5.0.3
###########################


###########################
###No need to edit below here
echo -e "\e[4;49;34m WRF-Hydro Release Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving latest community model code release\e[0m"

release=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/tags/$version)
git clone --branch $version https://github.com/NCAR/wrf_hydro_nwm_public
chmod -R 777 /home/docker/wrf_hydro_nwm_public

echo "Retrieved the following release: $version"

/bin/bash