{
  lib,
  pkgs,
  fontconfig | lib.MesonPackage
    = {
      name = "fontconfig",
      singleSource = {
        uri = "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.15.0.tar.gz",
        sha256sum = "f5f359d6332861bd497570848fcb42520964a9e83d5e3abe397b6b6db9bcaaf4",
      },
      biDrvs = lib.biMap [pkgs.freetype, pkgs.zlibNg, pkgs.gperf, pkgs.expat],
    }
}
