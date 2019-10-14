#!/bin/bash
docker build "$@" -f Dockerfile.training -t wrfhydro/wps:conus-training-v5.1.1 .

exit $?
