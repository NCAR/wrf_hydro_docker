#!/bin/bash

docker build "$@" -t wrfhydro/data_sixmile .

exit $?
