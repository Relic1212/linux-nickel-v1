{
  lib,
  fontconfig,
  freetype,
  zlibNg,
  gperf,
  pixman,
  wayland,
  waylandProtocols,
  libffi,
  libxkbcommon,
  expat,
  linuxHeaders,
  ncurses,
  readline,
  pcre2,
  pango,
  libpng,
  harfbuzz,
  glibDynamic,
  muslShared,
  hwdata,
  gobjectDynamic,
  cairoGobject,
  fribidi,
  gdkPixbufFull,
  libjpegTurbo,
  libepoxy,
  atSpi2Core,
  mesa2,
  libelf,
  libdrm,
  libpciaccess,
  llvmConfigStatic,
  spirvTools,
  spirvLlvmTranslator,
  llvmFull,

  gtk3 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/gtk/-/archive/3.24.43/gtk-3.24.43.tar.gz",
      # sha256sum = "ab197f76719fc875067671247533f8e5bd2bc090568ec17317de410d06397b7f"

      uri = "https://download.gnome.org/sources/gtk+/3.24/gtk%2B-3.24.43.tar.xz",
      sha256sum = "7e04f0648515034b806b74ae5d774d87cffb1a2a96c468cb5be476d51bf2f3c7",
    },
    llvmProvider = lib.singleBiMap llvmFull,

    biDrvs =
      lib.biMap [
        fontconfig,
        freetype,
        zlibNg,
        gperf,
        pixman,
        wayland,
        waylandProtocols,
        libffi,
        libxkbcommon,
        expat,
        linuxHeaders,
        ncurses,
        readline,
        pcre2,
        pango,
        #cairo,
        libpng,
        harfbuzz,
        glibDynamic,
        muslShared,
        hwdata,
        gobjectDynamic,
        cairoGobject,
        fribidi,
        gdkPixbufFull,
        libjpegTurbo,
        libepoxy,
        atSpi2Core,
        mesa2,
        libelf,
        libdrm,
        libpciaccess,
        llvmConfigStatic,
        spirvTools,
        spirvLlvmTranslator,
      ],

    extraMesonArgs = [
      "-Dgtk_doc=false",
      "-Dxinerama=no",
      "-Dtests=false",
      "-Ddemos=false",
      "-Dexamples=false",
      "-Dintrospection=false",
      "-Dcloudproviders=false",
      "-Dcolord=yes",
      # "-Dopengl=false",
      "-Dtracker3=false",
      "-Dwayland_backend=true",
      "-Dx11_backend=false",
      "-Dbuiltin_immodules=all",
      "-Dbroadway_backend=false",
      "-Dwin32_backend=false",
      "-Dquartz_backend=false",
      "-Dxinerama=no",
      "-Dprint_backends=file",
    ],
    unpackPhase = [
      "tar -xf /tmp/workdir/packed/7e04f0648515034b806b74ae5d774d87cffb1a2a96c468cb5be476d51bf2f3c7/gtk*-3.24.43.tar.xz --strip-components=1 -C /tmp/workdir/src"
    ]
  }
}
& {
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  libxml2,
  dbus,

  fribidi | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/fribidi/fribidi/archive/refs/tags/v1.0.16.tar.gz",
      sha256sum = "5a1d187a33daa58fcee2ad77f0eb9d136dd6fa4096239199ba31e850d397e8a8"
    },
    extraMesonArgs = [
      "-Ddocs=false",
    ]
  }
}
& {
  lib,

  pcre2,
  libffi,
  zlibNg,
  glib,
  libxml2,
  dbus,

  atSpi2Core | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/at-spi2-core/2.54/at-spi2-core-2.54.0.tar.xz",
      sha256sum = "d7eee7e75beddcc272cedc2b60535600f3aae6e481589ebc667afc437c0a6079"
    },

    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        libxml2,
        dbus,
      ],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },
  }
}
