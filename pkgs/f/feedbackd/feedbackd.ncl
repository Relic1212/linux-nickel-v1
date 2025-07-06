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
  libtiff,
  graphene,
  harfbuzzFull,
  kmod,
  openssl,
  zstd,
  utilLinux,
  eudev,
  gmobile,
  gudev,
  vala,
  libpsl,
  libxml2,
  jsonGlib,
  libyaml,
  libxmlb,
  libvorbis,
  libogg,
  libcanberra,
  gsound,
  libtool,
  llvmFull,

  feedbackd | lib.MesonPackage = {
    singleSource = {
      uri = "https://sources.phosh.mobi/releases/feedbackd/feedbackd-0.7.0.tar.xz",
      sha256sum = "c525932dfff2e16fe202bc3d5e3cc78949ba67a3192e60306b70db81ea725000"
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
        libtiff,
        graphene,
        harfbuzzFull,
        kmod,
        openssl,
        zstd,
        utilLinux,
        eudev,
        gmobile,
        gudev,
        vala,
        libpsl,
        libxml2,
        jsonGlib,
        libyaml,
        libxmlb,
        libvorbis,
        libogg,
        libcanberra,
        gsound,
        libtool,
      ],
    extraMesonArgs = [
      "-Dudev=true",
      "-Dtests=false",
      "-Dintrospection=disabled",
      "-Dvapi=false",
    ],

    preConfigurePhase = [
      "sed -i 's@shared_library@static_library@g' ${SRC}/libfeedback/meson.build"
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lltdl"
      ],
    },
  }
}
& {
  lib,
  epollShim,
  glib,
  pcre2,
  libffi,
  zlibNg,
  bison,
  libcap,
  libarchive,
  openssl,
  libpsl,
  libxml2,
  jsonGlib,
  libyaml,
  libxmlb,
  gdkPixbufFull,
  libpng,
  libjpegTurbo,
  libassuan,
  zstd,
  xz,
  lz4,
  xdgDbusProxy,
  m4,
  linuxHeaders,
  gperf,
  kmod,
  utilLinux,
  eudev,

  gmobile | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/World/Phosh/gmobile/-/archive/v0.2.1/gmobile-v0.2.1.tar.gz",
      sha256sum = "7e02fb5df110da70d85abac7d28cb8159b4456f5080e35ea892dc5df2e64b7f4"
    },
    biDrvs =
      lib.biMap [
        epollShim,
        glib,
        pcre2,
        libffi,
        zlibNg,
        bison,
        libcap,
        libarchive,
        openssl,
        libpsl,
        libxml2,
        jsonGlib,
        libyaml,
        libxmlb,
        gdkPixbufFull,
        libpng,
        libjpegTurbo,
        libassuan,
        zstd,
        xz,
        lz4,
        xdgDbusProxy,
        m4,
        linuxHeaders,
        gperf,
        kmod,
        utilLinux,
        eudev,
      ],
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dexamples=false",
      "-Dtests=false",
    ],

    #preConfigurePhase = [
    #  m%"sed -i 's@both_libraries@library@g' ${SRC}/src/meson.build"%
    #],
    patches = [
      {
        sha256sum = "729391c9e8273b82d813fbc7f69e114e3fd9b558a65f55c7dcbd23df2f702792",
        file = "gmobile.patch",
      }
    ]
  }
}
& {
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  vala,
  libcanberra,
  libogg,
  libvorbis,

  gsound | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gsound/-/archive/1.0.3/gsound-1.0.3.tar.gz",
      sha256sum = "ebee33c77f43bcae87406c20e051acaff08e86f8960c35b92911e243fddc7a0b"
    },

    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        vala,
        libcanberra,
        libogg,
        libvorbis,
      ],
    extraMesonArgs = [
      "-Dgtk_doc=false",
      "-Dintrospection=false",
      "-Denable_vala=false",
    ]
  }
}
& {
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  vala,
  libtool,
  gettext,
  pkgconf,
  libogg,
  libvorbis,

  libcanberra | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz",
      sha256sum = "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"
    },
    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        vala,
        libtool,
        gettext,
        pkgconf,
        libogg,
        libvorbis,
      ],
  }
}
& {
  lib,
  libogg,
  pkgconf,

  libvorbis | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.xz",
      sha256sum = "b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
    },
    biDrvs =
      lib.biMap [
        libogg,
        pkgconf,
      ]
  }
}
& {
  lib,

  libogg | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.xz",
      sha256sum = "c4d91be36fc8e54deae7575241e03f4211eb102afb3fc0775fbbc1b740016705"
    }
  }
}
