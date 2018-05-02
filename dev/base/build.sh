#!/bin/bash

docker build "$@" -t -q wrfhydro/dev:base .

exit $?
