#!/bin/bash

docker build "$@" -q -t wrfhydro/dev:base .

exit $?
