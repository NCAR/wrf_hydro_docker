#!/bin/bash

inst_ls=(04233300_VM.tar entrypoint.sh dev boot etc lib media opt root sbin sys usr bin home lib64 mnt proc run srv tmp var)
IFS=$'\n' inst=($(sort <<<"${inst_ls[*]}"))
#printf "%s\n" "${inst[@]}"
#echo ---------

current_ls=(`ls -1d *`)
IFS=$'\n' current=($(sort <<<"${current_ls[*]}"))
#printf "%s\n" "${current[@]}"
#echo ----------

newDir=`sort <(printf "%s\n" "${current[@]}") <(printf "%s\n" "${inst[@]}") <(printf "%s\n" "${inst[@]}") | uniq -u`
#echo NewDir: $newDir
#echo ----------

if [[ -z $newDir ]]; then
    echo 'No new volume was place in /. Please mount a data volume to / for the data. Exiting without copy.'
    exit 1
fi

nNewDirs=`echo "$newDir" | wc -w`
#echo $nNewDirs
if [[ $nNewDirs -ne 1 ]]; then
    echo "More than one directory has been mounted to /. Exiting without copy."
    exit 1
fi

if [[ ! -d $newDir ]]; then
    echo "/$newDir is not a directory. Exiting without copy."
    exit 1
fi

echo "Copying to /$newDir/."
cp /04233300_VM.tar $newDir/.

exec /bin/bash

exit 0
