{
  lib,
  drvs,
  feedbackd | lib.MesonPackage = {
    singleSource = {
      uri = "https://sources.phosh.mobi/releases/feedbackd/feedbackd-0.7.0.tar.xz",
      sha256sum = "c525932dfff2e16fe202bc3d5e3cc78949ba67a3192e60306b70db81ea725000"
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
      drvs.libtiff,
      drvs.graphene,
      drvs.harfbuzzFull,
      drvs.kmod,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.eudev,
      drvs.gmobile,
      drvs.gudev,
      drvs.vala,
      drvs.libpsl,
      drvs.libxml2,
      drvs.jsonGlib,
      drvs.libyaml,
      drvs.libxmlb,
      drvs.libvorbis,
      drvs.libogg,
      drvs.libcanberra,
      drvs.gsound,
      drvs.alsaLibs,
      drvs.libtool,
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
  drvs,
  gmobile | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/World/Phosh/gmobile/-/archive/v0.2.1/gmobile-v0.2.1.tar.gz",
      sha256sum = "7e02fb5df110da70d85abac7d28cb8159b4456f5080e35ea892dc5df2e64b7f4"
    },
    biDrvs = [
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.bison,
      drvs.libcap,
      drvs.libarchive,
      drvs.openssl,
      drvs.libpsl,
      drvs.libxml2,
      drvs.jsonGlib,
      drvs.libyaml,
      drvs.libxmlb,
      drvs.gdkPixbufFull,
      drvs.libpng,
      drvs.libjpegTurbo,
      drvs.libassuan,
      drvs.zstd,
      drvs.xz,
      drvs.lz4,
      drvs.xdgDbusProxy,
      drvs.m4,
      drvs.linuxHeaders,
      drvs.gperf,
      drvs.kmod,
      drvs.utilLinux,
      drvs.eudev,
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
  drvs,
  libvorbis | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.xz",
      sha256sum = "b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
    },
    biDrvs = [
      drvs.libogg,
      drvs.pkgconf,
    ]
  }
}
& {
  lib,
  drvs,
  libogg | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.xz",
      sha256sum = "c4d91be36fc8e54deae7575241e03f4211eb102afb3fc0775fbbc1b740016705"
    }
  }
}
