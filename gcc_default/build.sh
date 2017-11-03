#!/bin/bash

docker build "$@" -t wrfhydro/gcc_default .

exit $?
