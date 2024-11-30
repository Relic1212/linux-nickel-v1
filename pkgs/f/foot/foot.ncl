{
  lib,
  drvs,
  foot | lib.MesonPackage
    = {
      name = "foot",
      singleSource = {
        uri = "https://codeberg.org/dnkl/foot/releases/download/1.18.1/foot-1.18.1.tar.gz",
        sha256sum = "7bd2ff135fe611a049d19b89480a410eb0ae12befadf70cfa7055b6f359ee607",
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
      ],
      extraMesonArgs = [
        "-Ddocs=enabled",
        "-Dthemes=false",
        "-Dime=true",
        "-Dgrapheme-clustering=disabled",
        "-Dtests=false",
        "-Dutmp-backend=none",
        "-Dterminfo=disabled",
      ]
    }
}
