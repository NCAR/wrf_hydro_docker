#!/bin/bash

docker build "$@" -t wrfhydro/gcc_7 .

exit $?
