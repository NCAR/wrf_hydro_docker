#!/bin/bash

# Run the python script to run tests. All this does is run the run_tests.py script,
# so make sure it exists

source /home/docker/.bashrc

if [ ! -e "/home/docker/WrfHydroForcing/core/tests/run_tests.py" ]; then
    echo "run_tests.py not found. Please make sure the WrfHydroForcing branch to test "
    echo "has been checked out and is mapped to /home/docker/WrfHydroForcing"
    exit -1
fi

export PATH=/home/docker/grib2/wgrib2:$PATH
cd /home/docker/WrfHydroForcing/core/tests

args=$@
python run_tests.py $args

test_status=$?
exit $test_status
