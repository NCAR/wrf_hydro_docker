#!/bin/bash
docker build "$@" --no-cache -t wrfhydro/wps .

exit $?
