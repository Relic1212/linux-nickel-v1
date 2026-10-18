{
  lib,
  drvs,
  ignisGvc | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/ignis-sh/ignis-gvc/archive/refs/tags/v0.1.0.tar.gz",
      sha256sum = "6d0bf30be78e3b35b70f9364684dd7574120e82c918d4bfe39346f2c541808f6",
    },
    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://gitlab.gnome.org/GNOME/libgnome-volume-control/-/archive/0a4eda0cdc2deb352bebc70ec697c42af46094e4/libgnome-volume-control-0a4eda0cdc2deb352bebc70ec697c42af46094e4.tar.bz2",
          sha256sum = "255a41bd59db637db4327512fef87e54b20a9fc4e891e7085c5981e81389f748",
        },
        dest = "subprojects/gvc",
      }
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs dbus-1 libpulse)",
      ],
      PKG_CONFIG = null,

      _isStatic = false,
    },
    isStatic = false,
    extraMesonArgs = [
      #   "-Dgvc:static=true",
      #   "-Dgvc:introspection=false",
      "-Ddefault_library=both",
    ],
    preConfigurePhase = [
      m%"sed -i 's@shared_library@library@g' ${SRC}/subprojects/gvc/meson.build"%,
    ],
    pythonProvider = drvs.pythonDynamic,
    neverInclude = [
      drvs.zlibNg,
    ],
    biDrvs = [
      drvs.zlibNgPic,
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
      drvs.pulseaudio17,
      drvs.dbus,
    ],
  }
}
