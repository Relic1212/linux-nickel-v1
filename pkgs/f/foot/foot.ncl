{
  lib,
  pkgs,
  foot | lib.MesonPackage
    = {
      name = "foot",
      singleSource = {
        uri = "https://codeberg.org/dnkl/foot/releases/download/1.18.1/foot-1.18.1.tar.gz",
        sha256sum = "7bd2ff135fe611a049d19b89480a410eb0ae12befadf70cfa7055b6f359ee607",
      },
      biPkgs = [
        pkgs.tllist,
        pkgs.fcft,
        pkgs.fontconfig,
        pkgs.freetype,
        pkgs.zlibNg,
        pkgs.gperf,
        pkgs.pixman,
        pkgs.wayland,
        pkgs.waylandProtocols,
        pkgs.libffi,
        pkgs.libxkbcommon,
        pkgs.expat,
        pkgs.linuxHeaders,
      ],
      extraMesonArgs = [
        "-Ddocs=disabled",
        "-Dthemes=false",
        "-Dime=true",
        "-Dgrapheme-clustering=disabled",
        "-Dtests=false -Dutmp-backend=none",
        "-Dterminfo=disabled",
      ]
    }
}
