{
  lib,
  genimage | lib.Package = {
    #name = "genimage",
    extraFiles = [
      {
        file = "genimage.sh",
        sha256sum = "d9aa130ec29df62335fbb440237f1d5aea929b8b3e3a78de8b6b885968f58857",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
    ]
  }
}
