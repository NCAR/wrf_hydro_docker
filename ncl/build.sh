#!/bin/bash

docker build "$@" -t wrfhydro/ncl .

exit $?
