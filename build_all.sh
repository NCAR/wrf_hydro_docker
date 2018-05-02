#!/bin/bash

depends="$(cat build_deploy_deps.txt)"

for dd in $depends; do

    echo '------------------------------'
    echo "Building:  $dd"

    dd_dirname=$(dirname $dd)
    cd $dd_dirname

    ./build.sh 1>/dev/null || exit 1

    cd - 2&>1 > /dev/null
    echo
    
done

exit 0

