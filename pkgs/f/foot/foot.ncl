{
  lib,
  drvs,
  foot | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/dnkl/foot/archive/1.27.0.tar.gz",
      sha256sum = "4e6131cc859ec6a36569f1978cf3617cc3836a681d13d228ded1b4885dab7770",
    },
    biDrvs = [
      drvs.tllist,
      drvs.fcft,
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
      drvs.scdoc,
      drvs.ncurses,
      drvs.utf8proc,
    ],
    extraMesonArgs = [
      "-Ddocs=enabled",
      "-Dthemes=false",
      "-Dime=true",
      "-Dgrapheme-clustering=enabled",
      "-Dtests=false",
      "-Dutmp-backend=none",
      "-Dterminfo=enabled",
    ]
  }
}
