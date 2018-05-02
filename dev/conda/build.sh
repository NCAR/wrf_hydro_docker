#!/bin/bash

docker build "$@" -q -t wrfhydro/dev:conda .

exit $?
