#!/bin/bash

docker build "$@" -t wrfhydro/dev:base .

exit $?
