{
  lib,
  freetype,
  cairo,
  zlibNg,
  pixman,
  fontconfig,
  libpng,
  expat,

  harfbuzz | lib.MesonPackage = {
    #name = "harfbuzz",
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
        freetype,
        cairo,
        zlibNg,
        pixman,
        fontconfig,
        libpng,
        expat
      ]
  }
}
& {
  lib,
  freetype,
  cairo,
  zlibNg,
  pixman,
  fontconfig,
  libpng,
  expat,
  pcre2,
  libffi,
  glib,

  harfbuzz,
  harfbuzzFull | lib.MesonPackage = {
    singleSource = harfbuzz.singleSource,
    extraMesonArgs = [
      "-Dfreetype=enabled",
      "-Dcairo=enabled",
      "-Dglib=enabled",
    ],
    biDrvs =
      lib.biMap [
        freetype,
        cairo,
        zlibNg,
        pixman,
        fontconfig,
        libpng,
        expat,
        pcre2,
        libffi,
        glib,
      ]
  }
}
