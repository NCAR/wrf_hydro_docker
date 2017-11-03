#!/bin/bash

docker build "$@" -t wrfhydro/ubuntu .

exit $?
