{
  lib,
  genimage | lib.Package
    = {
      name = "genimage",
      extraFiles = [
        {
          file = "genimage.sh",
          sha256sum = "460f656ffc6091fb962ec8187dc3419b22cb57c2209f7cee36a8e5048e180670",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
      ]
    }
}
