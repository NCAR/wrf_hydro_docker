#!/bin/bash

docker build "$@" -t wrfhydro/dev:latest .

exit $?
