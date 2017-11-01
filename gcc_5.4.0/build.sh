#!/bin/bash

docker build "$@" -t wrfhydro/gcc_5.4.0 .

exit $?
