#!/bin/bash

docker build "$@" -t wrfhydro/testing:sixmile .

exit $?
