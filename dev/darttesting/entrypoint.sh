#!/bin/bash
if [ "$1" == "--help" ] ; then
    python run_tests_docker.py --help
    exit $?
fi

# Run the python script to run tests. All this does is run the run_tests.py script in the
# candidate dir with pre-set arguments for docker

args=$@
python run_tests_docker.py $args
test_status=$?

# This checks if the docker image is run in itneractive mode, if not it exits with exit code
if [ -t 0 ] ; then
    /bin/bash
else
    exit $test_status
fi


