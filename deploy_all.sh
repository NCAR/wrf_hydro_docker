#!/bin/bash

depends="$(cat deploy_dependencies.txt)"

for dd in $depends; do

    echo '------------------------------'
    echo "Building:  $dd"

    dd_dirname=$(dirname $dd)
    cd $dd_dirname

    build_cmd=$(grep wrfhydro build.sh)
    cmd_arr=(${build_cmd//;/ })
    name_tag=$(printf -- '%s\n' "${cmd_arr[@]}" | grep wrfhydro)
    #echo $name_tag

    ./build.sh

    docker push $name_tag

    cd - 2&>1 > /dev/null
    echo
        
    
done

exit 0

