let shellFuntions={
    unpackMaybe = m%"

    tar_unpack(){
        source=${1}
        dest=${2}
        tar xf ${source} -C ${dest} --no-same-owner
    }

    unzip_unpack(){
        source=${1}
        dest=${2}
        unzip ${source} -d ${dest}
    }

    unpack_maybe() {
        source=${1}
        dest=${2}
        if [ -d ${source} ]; then 
            cmd="cp -r"
        fi 
        case ${source} in
            *.tar) cmd="tar_unpack";;
            *.tar.*) cmd="tar_unpack";;
            *.tgz) cmd="tar_unpack";;
            *.zip) cmd="unzip_unpack";;
	    esac 

        stmp=$(realpath ${source})
        dtmp=$(mktemp)
        ${cmd} ${stmp} ${dtmp}
        if [ $(ls ${dtmp} | wc -l) -eq 1 ];then
            d=$(ls ${dtmp})
            if [ -d ${d} ];then
                cp -a ${d}/. ${dest}/
            fi 
        else
            cp -a ${dtmp}/. ${dest}/
        fi

    }
    
    "%

}in
shellFuntions