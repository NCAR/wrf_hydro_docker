#!/bin/bash
docker build "$@" -f Dockerfile.service -t wrfhydro/wps:conus .

exit $?
