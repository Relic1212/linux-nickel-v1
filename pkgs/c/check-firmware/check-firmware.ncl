{
  lib,
  checkFirmware | lib.Package
    = {
      name = "check-firmware",
      installPhase = [
        m%"
            install -d -m0755 ${DEST}/usr/bin
            echo '#!/bin/sh
            for f in $(find /lib/modules/ -type f -print | xargs modinfo {}|grep "firmware:"| cut -d " " -f8);do
                if [ ! -e /lib/firmware/${f} ];then
                    echo  "/lib/firmware/${f} does not exist!"
                fi
            done
            ' > ${DEST}/usr/bin/check-firmware
            chmod +x ${DEST}/usr/bin/check-firmware
            "%,
        m%"
            install -d -m0755 ${DEST}/usr/bin
            echo '#!/bin/sh
            for f in $(find /lib/modules/ -type f -print | xargs modinfo {}|grep "firmware:"| cut -d " " -f8);do
                if [ -e /lib/firmware.unneeded/${f} ];then
                    echo  "/lib/firmware.unneded/${f} does exist!"
                fi
            done
            ' > ${DEST}/usr/bin/check-unneded-firmware
            chmod +x ${DEST}/usr/bin/check-unneded-firmware
            "%
      ],
    }
}
