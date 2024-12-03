{
  lib,
  genimage | lib.Package
    = {
      name = "genimage",
      extraFiles = [
        {
          file = "genimage.sh",
          sha256sum = "6814bdbd74083b708a8c6f8ccb3085449022ba8cde0d62919b583abe7dfdc7fe",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/genimage.sh ${DEST}/usr/bin/genimage",
      ]
    }
}
