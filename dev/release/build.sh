#!/bin/bash

docker build "$@" -t wrfhydro/dev:release .

exit $?
