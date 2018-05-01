#!/bin/bash

CONFIRM=$(wget --quiet --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
wget "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $2

