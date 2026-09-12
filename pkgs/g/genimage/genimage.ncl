{
  lib,
  genimage | lib.Package = {
    # name = "genimage",
    # extraFiles = [
    #   {
    #     file = "genimage.sh",
    #     sha256sum = "8698b5e33b5b8d4c2cc7fd0acebb6ec9cbaaa51c4cab7bd352eeb7cb7f39672e",
    #   }
    # ],

    installPhase = [
      lib.functions.writeFile "genimage" (import "genimage.sh" as 'Text),
      "chmod +x genimage",
      # "install -d -m0755 ${DEST}/usr/bin",
      "install -Dm0755 genimage ${DEST}/usr/bin/genimage",
    ]
  }
}
