{
  lib,
  pkgs,
  pango | lib.MesonPackage
    = {
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

      biPkgs = [
        pkgs.glib,
        pkgs.pcre2,
        pkgs.libffi,
        pkgs.freetype,
        pkgs.fontconfig,
        pkgs.zlibNg,
        pkgs.harfbuzz,
        pkgs.cairo,
        pkgs.pixman,
        pkgs.libpng,
        pkgs.expat,
      ]
    }
}
