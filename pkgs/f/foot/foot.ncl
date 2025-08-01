{
  lib,
  drvs,
  foot | lib.MesonPackage = {
    name = "foot",
    singleSource = {
      uri = "https://codeberg.org/dnkl/foot/releases/download/1.23.1/foot-1.23.1.tar.gz",
      sha256sum = "e42cc9d43f26d048cbe0eca9fc7e25a4759f2e6f4bca5835b12a17629cb10192",
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
