{
  lib,
  pixman,
  zlibNg,
  freetype,
  fontconfig,
  libpng,
  expat,

  cairo | lib.MesonPackage = {
    singleSource.uri = "https://gitlab.freedesktop.org/cairo/cairo/-/archive/1.18.2/cairo-1.18.2.tar.gz",
    singleSource.sha256sum = "7bbfb469b89b1f60584b4f39a1366789b7625a5796905870e108b6c0e8ca8216",
    biDrvs =
      lib.biMap [
        pixman,
        zlibNg,
        freetype,
        fontconfig,
        libpng,
        expat,
      ],
    extraMesonArgs = [
      "-Dzlib=enabled",
      "-Dfreetype=enabled",
      "-Dfontconfig=enabled",
      "-Dpng=enabled"
    ],
  }
}
& {
  lib,

  cairo,
  cairo3 | lib.MesonPackage =
    cairo
    & {
      extraMesonArgs | priority 1 =
        cairo.extraMesonArgs
        @ [
          "-DCAIRO_HAS_GOBJECT_FUNCTIONS=1"
        ]
    }
}
& {

  lib,
  cairo,
  glib,
  gobjectDynamic,
  libffi,
  pcre2,
  cairoGobject =
    cairo
    & {
      extraMesonArgs | priority 1 =
        cairo.extraMesonArgs
        @ [
          "-Dglib=enabled",
        ],
      biDrvs | priority 1 =
        cairo.biDrvs
        @ lib.biMap [
          glib,
          gobjectDynamic,
          libffi,
          pcre2,
        ]
    }
}
