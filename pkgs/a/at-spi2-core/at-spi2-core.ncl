{
  lib,
  drvs,
  atSpi2Core | lib.MesonPackage = {
    singleSource = {
      # uri = "https://download.gnome.org/sources/at-spi2-core/2.54/at-spi2-core-2.54.0.tar.xz",
      # sha256sum = "d7eee7e75beddcc272cedc2b60535600f3aae6e481589ebc667afc437c0a6079",
      uri = "https://download.gnome.org/sources/at-spi2-core/2.62/at-spi2-core-2.62.0.tar.xz",
      sha256sum = "03a94f7bf35f300daf2843a37cdf36479a91bc53f59a8ea437c79e25d95d1de3",
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },

    preConfigurePhase = [
      m%"sed -i 's@shared_module@library@g' ${SRC}/atk-adaptor/meson.build"%,
    ],

    postInstallPhase = [
      m%"sed -i 's@-DG_LOG_DOMAIN="atspi"@@g' ${DEST}/usr/lib/pkgconfig/atspi-2.pc"%,
    ],

    biDrvs = [
      drvs.libxml2,
    ],
    pDrvs = [
      drvs.glib,
      drvs.dbus,
    ],
  }
}
& {

  lib,
  drvs,
  atSpi2Core,
  atSpi2CoreIntrospection | lib.MesonPackage = {
    singleSource = atSpi2Core.singleSource,

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
      PKG_CONFIG = null,
      _isStatic = false,
    },
    extraMesonArgs = [
      "-Dintrospection=enabled",
    ],

    preConfigurePhase = [
      m%"sed -i 's@shared_module@library@g' ${SRC}/atk-adaptor/meson.build"%,
    ],

    postInstallPhase = [
      m%"sed -i 's@-DG_LOG_DOMAIN="atspi"@@g' ${DEST}/usr/lib/pkgconfig/atspi-2.pc"%,
    ],
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.libxml2,
      drvs.muslShared,
      drvs.pythonSetuptools80,
      drvs.ldd,
      # drvs.glibGobject & { priority = -2 },
      # drvs.pangoGobject & { priority = -1 },
      # drvs.harfbuzzGobjectDynamic & { priority = -1 },
      # drvs.gdkPixbufIntrospection & { priority = -1 },
      # drvs.grapheneIntrospection & { priority = -1 },
      drvs.glibGobjectDynamic & { priority = -1 },
      drvs.gobjectDynamicCairo2 & { priority = -1 },
    ],
    pDrvs = [
      drvs.glib,
      drvs.dbus,
      # drvs.gobjectDynamic,
    ],
  }
}
