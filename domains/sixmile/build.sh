#!/bin/bash

docker build "$@" -t wrfhydro/domains:sixmile_NY . 

exit $?
