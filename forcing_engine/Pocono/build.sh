#!/bin/bash
docker build "$@" -t wrfhydro/forcing_engine .

exit $?
