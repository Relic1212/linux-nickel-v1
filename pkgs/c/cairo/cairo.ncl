{
  lib,
  pkgs,
  cairo | lib.MesonPackage
    = {
      singleSource.uri = "https://gitlab.freedesktop.org/cairo/cairo/-/archive/1.18.2/cairo-1.18.2.tar.gz",
      singleSource.sha256sum = "7bbfb469b89b1f60584b4f39a1366789b7625a5796905870e108b6c0e8ca8216",
      biDrvs =
        lib.biMap [
          pkgs.pixman,
          pkgs.zlibNg,
          pkgs.freetype,
          pkgs.fontconfig,
          pkgs.libpng,
          pkgs.expat,
        ],
      extraMesonArgs = [
        "-Dzlib=enabled",
        "-Dfreetype=enabled",
        "-Dfontconfig=enabled",
        "-Dpng=enabled"
      ],
    }
}
