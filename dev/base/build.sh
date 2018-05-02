#!/bin/bash

docker build "$@" -t wrfhydro/dev:base . 1>dev/null

exit $?
