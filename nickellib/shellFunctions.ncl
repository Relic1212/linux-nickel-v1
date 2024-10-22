let shellFuntions={
    unpackMaybe = m%"

    tar_unpack(){
        source=${1}
        dest=${2}
        unpack_cmd="tar xf ${source} -C ${dest} --no-same-owner"
        printf "unpacking tar archive with command ${unpack_cmd}\n"
        ${unpack_cmd}
    }

    unzip_unpack(){
        source=${1}
        dest=${2}
        unzip ${source} -d ${dest}
    }

    unpack_maybe() {
        source_dir=${1}
        source_file=$(ls ${source_dir})
        source="${source_dir}/${source_file}"

        srcdest=${2}
        cmd="cp"
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
        dtmp=$(mktemp -d)
        printf "running command ${cmd} ${stmp} ${dtmp}\n"
        ${cmd} ${stmp} ${dtmp}
        if [ $(ls ${dtmp} | wc -l) -eq 1 ];then
            d=$(ls ${dtmp})
            dd="${dtmp}/${d}"
            if [ -d ${dd} ];then
                copy_cmd="cp -a ${dd}/. ${srcdest}/"
            else
                copy_cmd="cp -a ${dtmp}/. ${srcdest}/"

            fi 
        else
            copy_cmd="cp -a ${dtmp}/. ${srcdest}/"
        fi
        printf "copyying files to src dir: ${copy_cmd}\n"
        ${copy_cmd}
    }
    
    "%

}in
shellFuntions