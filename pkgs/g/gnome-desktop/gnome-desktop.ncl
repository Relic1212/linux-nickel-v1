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
  cairo,
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
  gtk3,
  eudev,
  kmod,
  xz,
  openssl,
  zstd,
  utilLinux,
  gsettingsDesktopSchemas,
  xkeyboardConfig,
  isoCodes,
  libseccomp,
  llvmFull,

  gnomeDesktop | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources//gnome-desktop/44/gnome-desktop-44.1.tar.xz",
      sha256sum = "ae7ca55dc9e08914999741523a17d29ce223915626bd2462a120bf96f47a79ab"
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
        cairo,
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
        gtk3,
        eudev,
        kmod,
        xz,
        openssl,
        zstd,
        utilLinux,
        gsettingsDesktopSchemas,
        xkeyboardConfig,
        isoCodes,
        libseccomp,
      ],
    extraMesonArgs = [
      "-Dbuild_gtk4=false",
      "-Ddesktop_docs=false",
      "-Ddebug_tools=false",
      "-Dintrospection=false",
    ]
  }
}
& {
  lib,
  glib,
  pcre2,
  libffi,
  zlibNg,

  gsettingsDesktopSchemas | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/gsettings-desktop-schemas/47/gsettings-desktop-schemas-47.1.tar.xz",
      sha256sum = "a60204d9c9c0a1b264d6d0d134a38340ba5fc6076a34b84da945d8bfcc7a2815"
    },
    biDrvs =
      lib.biMap [
        glib,
        pcre2,
        libffi,
        zlibNg,
      ],
    extraMesonArgs = [
      "-Dintrospection=false"
    ]
  }
}
& {

  lib,
  pythonFull,
  libtool,
  gettext,

  isoCodes | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v4.17.0/iso-codes-v4.17.0.tar.gz",
      sha256sum = "dd5ca13db77ec6dd1cc25f5c0184290a870ec1fed245d8e39a04ff34f59076c3"
    },
    biDrvs =
      lib.biMap [
        pythonFull,
        libtool,
        gettext,
      ]
  }
}
