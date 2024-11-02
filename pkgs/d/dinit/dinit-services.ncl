{
  lib,
  dinitServices | lib.Package
    = {
      extraFiles = [{ file = "files-services", sha256sum = "13533a1365b747ac95e6acfbf34cc42ce68a5b273aaf041a96f41cb87b2dc5ee" }],

      installPhase = [
        m%"
            cp -r /tmp/workdir/files/files-services/etc ${DEST}/etc
            cd ${DEST}/etc/dinit.d/scripts
            for f in $(ls);do
                chmod +x ${f}
            done
            "%
      ]
    }
}
