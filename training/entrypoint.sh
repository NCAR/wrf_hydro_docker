#!/bin/bash

echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving latest community model code release\e[0m"

release=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/latest)
version=$(echo "$release" | grep "tag_name" | cut -d : -f 2,3 |  tr -d \")
assetURL=$(echo "$release" | grep "browser_download_url" | cut -d : -f 2,3 |  tr -d \")
echo "$assetURL" | wget -qi -
tar -xf wrf_hydro_nwm_public-*.tar.gz
rm wrf_hydro_nwm_public-*.tar.gz
echo "Retrieved the following release: $version"

/bin/bash