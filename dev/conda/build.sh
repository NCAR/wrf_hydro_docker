#!/bin/bash

docker build "$@" -t wrfhydro/dev:conda .

exit $?
