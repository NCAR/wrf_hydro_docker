#!/bin/bash
docker build "$@" -t wrfhydro/wps .

exit $?
