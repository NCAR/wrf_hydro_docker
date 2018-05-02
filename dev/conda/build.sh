#!/bin/bash

docker build "$@" -t -q wrfhydro/dev:conda .

exit $?
