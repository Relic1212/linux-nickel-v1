{
  lib,
  genimage | lib.Package
    = {
      name = "genimage",
      extraFiles = [
        {
          file = "genimage.sh",
          sha256sum = "72b08a6c710d5f8cc67520d37a81eed7cf48606f4b8e5a3a72d789444e02ea53",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
      ]
    }
}
