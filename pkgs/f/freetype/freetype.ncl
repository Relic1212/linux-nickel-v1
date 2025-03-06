{
  lib,
  pkgs,
  freetype | lib.MesonPackage = {
    name = "freetype",
    singleSource = {
      uri = "https://download.savannah.gnu.org/releases/freetype/freetype-2.13.3.tar.gz",
      sha256sum = "5c3a8e78f7b24c20b25b54ee575d6daa40007a5f4eea2845861c3409b3021747",
    },
    biDrvs =
      lib.biMap [
        pkgs.zlibNg,
      ]
  }
}
