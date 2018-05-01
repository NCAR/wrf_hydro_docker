#!/bin/bash

depends="$(cat build_deploy_deps.txt)"

for dd in $depends; do

    echo '------------------------------'

    dd_dirname=$(dirname $dd)
    cd $dd_dirname

    build_cmd=$(grep wrfhydro build.sh)
    cmd_arr=(${build_cmd//;/ })
    name_tag=$(printf -- '%s\n' "${cmd_arr[@]}" | grep wrfhydro)
    echo "Deploying: $name_tag"

    docker push $name_tag

    cd - 2&>1 > /dev/null
    echo       
   
done

exit 0

