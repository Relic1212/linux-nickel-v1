{
  lib,
  pkgs,
  fcft | lib.MesonPackage
    = {
      name = "fcft",
      singleSource = {
        uri = "https://codeberg.org/dnkl/fcft/releases/download/3.1.8/fcft-3.1.8.tar.gz",
        sha256sum = "028099126692625873410889a1d76cd82d5a71b5e350bd618320e48db15a8636"
      },
      biPkgs = [
        pkgs.fontconfig,
        pkgs.freetype,
        pkgs.zlibNg,
        pkgs.gperf,
        pkgs.pixman,
        pkgs.tllist,
        pkgs.expat,
      ]
    }
}
