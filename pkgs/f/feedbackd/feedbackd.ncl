{
  lib,
  drvs,
  feedbackd | lib.MesonPackage = {
    singleSource = {
      uri = "https://sources.phosh.mobi/releases/feedbackd/feedbackd-0.7.0.tar.xz",
      sha256sum = "c525932dfff2e16fe202bc3d5e3cc78949ba67a3192e60306b70db81ea725000",
      # uri = "https://sources.phosh.mobi/releases/feedbackd/feedbackd-0.8.10.tar.xz",
      # sha256sum = "b7e7d9c284b5327ec559b1dda051bc5295d4a907e4c7aa801168fa820b18c054",
    },

    extraMesonArgs = [
      "-Dudev=true",
      "-Dtests=false",
      "-Dintrospection=disabled",
      "-Dvapi=false",
    ],

    preConfigurePhase = [
      "sed -i 's@shared_library@static_library@g' ${SRC}/libfeedback/meson.build"
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libtool,
    ],
    pDrvs = [
      drvs.gmobile,
      drvs.gsound,
      drvs.gudev,
    ],
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

    pDrvs = [
      drvs.gdkPixbufFull,
      drvs.jsonGlib,
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
      drvs.pkgconf,
    ],
    pDrvs = [
      drvs.libogg,
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
