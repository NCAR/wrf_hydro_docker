#!/bin/bash
docker build "$@" -t wrfhydro/coupled_training:v5.1.1 .

exit $?
