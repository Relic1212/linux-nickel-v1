{
  lib,
  drvs,
  autotiling | lib.SetuptoolPackage
    = {
      singleSource = {
        uri = "https://github.com/nwg-piotr/autotiling/archive/refs/tags/v1.9.3.tar.gz",
        sha256sum = "3270a28de977f375c80984ef50f7433cb03cfdf198b079ae9c80d1513f0e9176"
      }
    }
}
