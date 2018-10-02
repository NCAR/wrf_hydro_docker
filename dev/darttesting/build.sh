#!/bin/bash

docker build "$@" -t wrfhydro/dev:darttesting .

exit $?
