{
  lib,
  drvs,
  atSpi2Core | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/at-spi2-core/2.54/at-spi2-core-2.54.0.tar.xz",
      sha256sum = "d7eee7e75beddcc272cedc2b60535600f3aae6e481589ebc667afc437c0a6079"
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },

    postInstallPhase = [
      m%"sed -i 's@-DG_LOG_DOMAIN="dbind"@@g' ${DEST}/usr/lib/pkgconfig/atspi-2.pc"%
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
