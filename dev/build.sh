#!/bin/bash

docker build "$@" -t wrfhydro/dev .

exit $?
