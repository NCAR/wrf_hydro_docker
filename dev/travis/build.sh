#!/bin/bash

docker build "$@" -t wrfhydro/dev:travis .

exit $?
