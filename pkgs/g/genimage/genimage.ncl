{
  lib,
  genimage | lib.Package
    = {
      name = "genimage",
      extraFiles = [
        {
          file = "genimage.sh",
          sha256sum = "15d14ad473b2f07b874aa26ef4a0dd9a35bfe68af8875905789f8982c8b91c09",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
      ]
    }
}
