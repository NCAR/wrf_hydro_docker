#!/bin/bash

docker build "$@" -t wrfhydro/domains:sixmile .

exit $?
