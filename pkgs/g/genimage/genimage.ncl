{
  lib,
  genimage | lib.Package = {
    name = "genimage",
    extraFiles = [
      {
        file = "genimage.sh",
        sha256sum = "5d9554628956a5232baa104536fe09e53f9292f811e0f28ba8958bea9d303fc7",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
    ]
  }
}
