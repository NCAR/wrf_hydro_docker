#!/bin/bash

docker build "$@" -t wrfhydro/dev:r .

exit $?
