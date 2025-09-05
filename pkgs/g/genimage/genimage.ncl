{
  lib,
  genimage | lib.Package = {
    name = "genimage",
    extraFiles = [
      {
        file = "genimage.sh",
        sha256sum = "3a3d93941f0b53d1ed5c0f1871b20119256081245db5123c17a647536a959af9",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
    ]
  }
}
