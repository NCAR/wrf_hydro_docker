#!/bin/bash
mv Dockerfile.training Dockerfile
docker build "$@" -t wrfhydro/wps .

exit $?
