#!/bin/bash

docker build "$@" -t wrfhydro/wrf_hydro_forcing:latest .

exit $?
