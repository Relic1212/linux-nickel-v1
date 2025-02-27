{
  lib,
  pkgs,
  harfbuzz | lib.MesonPackage
    = {
      name = "harfbuzz",
      singleSource = {
        uri = "https://github.com/harfbuzz/harfbuzz/releases/download/10.0.1/harfbuzz-10.0.1.tar.xz",
        sha256sum = "b2cb13bd351904cb9038f907dc0dee0ae07127061242fe3556b2795c4e9748fc"
      },
      extraMesonArgs = [
        "-Dfreetype=enabled",
        "-Dcairo=enabled"
      ],
      biDrvs =
        lib.biMap [
          pkgs.freetype,
          pkgs.cairo,
          pkgs.zlibNg,
          pkgs.pixman,
          pkgs.fontconfig,
          pkgs.libpng,
          pkgs.expat
        ]
    }
}


&
{
  lib,
  drvs,
  harfbuzz,
  harfbuzzFull | lib.MesonPackage = {
    singleSource = harfbuzz.singleSource,
     extraMesonArgs = [
        "-Dfreetype=enabled",
        "-Dcairo=enabled",
        "-Dglib=enabled",

      ],
      biDrvs =
         [
          drvs.freetype,
          drvs.cairo,
          drvs.zlibNg,
          drvs.pixman,
          drvs.fontconfig,
          drvs.libpng,
          drvs.expat,

        drvs.pcre2,
        drvs.libffi,
          drvs.glib,
        ]

  }
}