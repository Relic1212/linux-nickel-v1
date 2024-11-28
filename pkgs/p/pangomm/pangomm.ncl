{
  lib,
  drvs,
  pangomm | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/pangomm/2.46/pangomm-2.46.4.tar.xz",
        sha256sum = "b92016661526424de4b9377f1512f59781f41fb16c9c0267d6133ba1cd68db22"
      },

      llvmProvider = drvs.llvmFull,
      biDrvs = [
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        drvs.mesa2,
        drvs.libelf,
        drvs.libdrm,
        drvs.libpciaccess,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs."gtk+3",
        drvs."libsigc++2",
        drvs."cairomm-1.0",
        drvs.glibmm
      ],
    }
}
& {
  lib,
  drvs,
  "pangomm-1.0" | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/pango/1.54/pango-1.54.0.tar.xz",
        sha256sum = "8a9eed75021ee734d7fc0fdf3a65c3bba51dfefe4ae51a9b414a60c70b2d1ed8"
      },

      llvmProvider = drvs.llvmFull,
      pythonProvider = drvs.pythonDynamic,

      biDrvs = [
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        drvs.mesa2,
        drvs.libelf,
        drvs.libdrm,
        drvs.libpciaccess,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs."gtk+3",
        drvs."libsigc++2",
        drvs."cairomm-1.0",
        drvs.glibmm,
        drvs.pythonSetuptools,
      ],
      extraMesonArgs = [
        "-Dintrospection=disabled",
      ]
    }
}
