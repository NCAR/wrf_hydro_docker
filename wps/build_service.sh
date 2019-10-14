#!/bin/bash
mv Dockerfile.service Dockerfile
docker build "$@" -t wrfhydro/wps .

exit $?
