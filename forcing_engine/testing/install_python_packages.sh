#!/bin/bash

# Install python packages using the repo's requirements.txt and setup.py
# so make sure it exists

source /home/docker/.bashrc
export PATH=$HOME/grib2/wgrib2:$PATH

if [ ! -e "/home/docker/WrfHydroForcing/requirements.txt" ]; then
    echo "requirements.txt not found. Please make sure the WrfHydroForcing branch to test "
    echo "has been checked out and is mapped to /home/docker/WrfHydroForcing"
    exit -1
fi

cd /home/docker/WrfHydroForcing
echo "Upgrading pip"
python -m pip install -q --upgrade pip
echo "Installing from requirements.txt"
pip install -q -r requirements.txt
echo "Installing esmpy and mpi4py"
conda install -y -q -c conda-forge esmpy mpi4py > /dev/null 2>&1
echo "Running setup.py"
python setup.py install > /dev/null 2>&1

exit 0 
