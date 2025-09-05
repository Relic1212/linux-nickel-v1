{
  lib,
  genimage | lib.Package = {
    name = "genimage",
    extraFiles = [
      {
        file = "genimage.sh",
        sha256sum = "08eb9f5e005831351502cb4f94c3699ea60009e81730676a06b8afb579c842d7",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
    ]
  }
}
