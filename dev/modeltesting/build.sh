#!/bin/bash

docker build "$@" -t wrfhydro/dev:modeltesting .

exit $?
