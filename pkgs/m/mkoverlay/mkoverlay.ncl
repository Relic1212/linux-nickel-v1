{
  lib,
  drvs,
  mkoverlay | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      m%"
echo '#!/bin/sh -e

if [ ! -d ${1} ]; then
	echo "${1} is not a directory"
	exit 1
fi
d=$(mktemp -d)
mkdir -p ${d}/upper
mkdir -p ${d}/work

mount -t overlay overlay -o lowerdir=${1},upperdir=${d}/upper,workdir=${d}/work ${1}
' > ${DEST}/usr/bin/mkoverlay
"%,
      "chmod +x ${DEST}/usr/bin/mkoverlay",
    ]
  }
}
