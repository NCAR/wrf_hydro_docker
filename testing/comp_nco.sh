#!/bin/bash                                                                                                                                  
comp_nco() {

    local allOldFinalFiles=`ls $1/*201306020000* $1/*2013-06-02_00:00*`

    local errorSum=0
    for fff in $allOldFinalFiles; do
        ff=`basename $fff`
        echo
        echo ">>> $ff file comparison <<<"
        ncdiff -O $2/$ff $1/$ff  diff.nc || \
            { echo "New file run.1.new/$ff is missing." ; errorSum=$(($errorSum+1)); continue; }

        ## This is super ad-hoc >>>> FRAGILE <<<<                                                                                            
        theVars=`ncVarList diff.nc`
        echo "$theVars" > theVars.txt
        echo -e "time\nreference_time\nx\ny\ncrs\ndepth\nfeature_id\nlatitude\nlongitude\nstationId"> ignoreVars.txt
        local theVars=`sort theVars.txt ignoreVars.txt ignoreVars.txt | uniq -u`

        for vv in $theVars; do
            theResult=`ncVarRng $vv diff.nc`
            #echo $theResult                                                                                                                 
            local tmp=`echo $theResult | cut -d'(' -f2- | tr -d '\n' | sed 's/[^0-9]*//g' | egrep [1-9]  `
            local anyNonZeros=`echo $tmp | wc -w`
            if [[ $anyNonZeros -ne 0 ]]; then
                echo -e "\e[5;49;31mThe result was not zero for variable $vv\e[0m"
                echo $theResult
                errorSum=$(($errorSum+1))
            fi
        done
    done
    echo -e "\e[7;49;31mTotal comparison errors: $errorSum\e[0m"
}
