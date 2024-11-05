{
  lib,
  genimage | lib.Package
    = {
      name = "genimage",
      extraFiles = [
        {
          file = "genimage.sh",
          sha256sum = "3cd84c81f505485ee69a527189eb7228a0c582f09c69c53abd69cf12947d47e1",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
      ]
    }
}
