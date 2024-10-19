let shellFuntions={
    unpackMaybe = m%"
    unpack_maybe() {
        source=${1}
        dest=${2}
        if [ -d ${source} ]; then 
            cmd="cp -r"
        fi 
        case ${source} in
            *.tar) cmd="tar xf";;
            *.tar.*) cmd="tar xf";;
            *.tgz) cmd="tar xf";;
            *.zip) cmd="unzip";;
	    esac 

        stmp=$(realpath ${source})
        dtmp=$(mktemp)
        _olddir=${pwd}
        cd ${dtmp}
        ${cmd} ${stmp}
        if [ $(ls | wc -l) -eq 1 ];then
            d=$(ls)
            if [ -d ${d} ];then
                cp -a ${d}/. .
                rm -r ${d} 
            fi 
        fi
        cd ${_olddir}
        cp -a ${_dtmp}/. ${dest}/


    }
    
    "%

}in
shellFuntions