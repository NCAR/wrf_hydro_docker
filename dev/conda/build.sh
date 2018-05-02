#!/bin/bash

docker build "$@" -t wrfhydro/dev:conda . 1>dev/null

exit $?
