#!/bin/bash
docker build "$@" -t wrfhydro/coupled_training:v5.0.x .

exit $?
