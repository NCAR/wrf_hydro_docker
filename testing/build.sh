#!/bin/bash

docker build "$@" -t wrfhydro/testing .

exit $?
