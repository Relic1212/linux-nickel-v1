{
  lib,
  drvs,
  qtxdgTools | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/qtxdg-tools/archive/refs/tags/4.3.0.tar.gz",
      sha256sum = "eb86b9b622bf61947a234a4cb701c6531255c4d0144ba783f3f16a5afa53bfbb",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        # "-Wl,--allow-multiple-definition",
        "$(pkg-config --static --libs glib-2.0 gmodule-2.0 expat)",
      ],
    },
    biDrvs = [
      drvs.acl,
      drvs.attr,
      drvs.duktape,
      drvs.elogindWithPolkit,
      drvs.kwindowsystem,
      drvs.layerShellQt,
      drvs.libcap,
      drvs.liblxqt,
      drvs.libpamFinalUdev,
      drvs.libqtxdg,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxext,
      drvs.libxfixes,
      drvs.libxrender,
      drvs.libxss,
      drvs.lxqtBuildTools,
      drvs.plasmaWaylandProtocols,
      drvs.polkit,
      drvs.polkitQt6,
      drvs.xcbProto,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
    ],
  }
}
