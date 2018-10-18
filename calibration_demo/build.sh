#!/bin/bash
docker build "$@" -t wrfhydro/calibdemo .

exit $?
