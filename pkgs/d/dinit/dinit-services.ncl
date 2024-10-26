{
  lib,
  dinitServices | lib.Package
    = {
      name = "dinit-services",
      extraFiles = [{ file = "files-services", sha256sum = "dad4e0dfcdd967847aa871254435793fa10d61de6d9416603f3b1e852d0a71c2" }],

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
