#!/bin/bash

docker build "$@" -t wrfhydro/gcc_8.0 .

exit $?
