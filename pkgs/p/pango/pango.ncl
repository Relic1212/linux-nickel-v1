{
  lib,
  drvs,
  pango | lib.MesonPackage = {
    name = "pango",
    singleSource = {
      uri = "https://download.gnome.org/sources/pango/1.54/pango-1.54.0.tar.xz",
      sha256sum = "8a9eed75021ee734d7fc0fdf3a65c3bba51dfefe4ae51a9b414a60c70b2d1ed8",
    },
    extraMesonArgs = [
      "-Dgtk_doc=false",
      "-Dxft=disabled",
      "-Dintrospection=disabled"
    ],
    preConfigurePhase = [
      # like Kiss Linux does
      ": > ${SRC}/tests/meson.build",
      ": > ${SRC}/examples/meson.build",
      ": > ${SRC}/docs/meson.build"
    ],
    patches = [{ file = "kisslinux-no-fribidi.patch", sha256sum = "fb69568c89cc1c00a3d5f5aaffa048ffe2d1d846a6153f7c7c2665717e10191f" }],

    biDrvs = [
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.cairo,
      drvs.pixman,
      drvs.libpng,
      drvs.expat,
    ]
  }
}
& {
  lib,
  drvs,
  pango,
  pango_1_56 =
    pango
    & {
      singleSource | priority 1 = {
        uri = "https://download.gnome.org/sources/pango/1.56/pango-1.56.1.tar.xz",
        sha256sum = "426be66460c98b8378573e7f6b0b2ab450f6bb6d2ec7cecc33ae81178f246480"
      },
      patches | priority 1 = [],
      biDrvs | priority 1 =
        pango.biDrvs
        @ [
          drvs.fribidi
        ]
    }
}
