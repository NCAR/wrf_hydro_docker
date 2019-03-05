#!/bin/bash

docker build "$@" -t wrfhydro/ford .

exit $?
