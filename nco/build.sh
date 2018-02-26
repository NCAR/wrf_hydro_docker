#!/bin/bash

docker build "$@" -t wrfhydro/nco .

exit $?
