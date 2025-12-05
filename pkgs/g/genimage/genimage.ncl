{
  lib,
  genimage | lib.Package = {
    name = "genimage",
    extraFiles = [
      {
        file = "genimage.sh",
        sha256sum = "8698b5e33b5b8d4c2cc7fd0acebb6ec9cbaaa51c4cab7bd352eeb7cb7f39672e",
      }
    ],

    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
    ]
  }
}
