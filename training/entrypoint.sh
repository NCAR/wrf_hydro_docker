#!/bin/bash
mkdir /home/docker/wrf-hydro-training
chmod -R 777 /home/docker/wrf-hydro-training
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving latest community model code release\e[0m"

release=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/latest)
version=$(echo "$release" | grep "tag_name" | cut -d : -f 2,3 |  tr -d \")
version=$(echo $version | tr "," " ")
#assetURL=$(echo "$release" | grep "browser_download_url" | cut -d : -f 2,3 |  tr -d \")
#echo "$assetURL" | wget -qi -
#tar -xf wrf_hydro_nwm_public-*.tar.gz
#rm wrf_hydro_nwm_public-*.tar.gz
#mv wrf_hydro_nwm_public-* wrf_hydro_nwm_public
git clone --branch $version https://github.com/NCAR/wrf_hydro_nwm_public
#chmod -R 777 ~/wrf_hydro_nwm_public
mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public
echo "Retrieved the following release: $version"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"

exampleCaseURL=$(echo "$release" | grep 'testcase' \
| grep "browser_download_url" \
| cut -d : -f 2,3 |  tr -d \")

echo "$exampleCaseURL" | wget -qi -
tar -xf *testcase*.tar.gz
rm *testcase*.tar.gz
#chmod -R 777 ~/example_case
mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case
echo "Retrieved the test case for release: $version"


echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mTraining Jupyter notebook server running\e[0m"
echo
echo "Open your browser to the following address to access notebooks"
echo "localhost:8888"
echo
echo "The password to login is 'nwmtraining'"
echo 
echo "Type ctrl-C then y to shut down container." 
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

jupyter notebook --ip 0.0.0.0 --no-browser 
