{
  lib,
  drvs,
  libxss | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/lib/libXScrnSaver-1.2.5.tar.xz",
      sha256sum = "5057365f847253e0e275871441e10ff7846c8322a5d88e1e187d326de1cd8d00",
    },
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.libxext,
    ],
  }
}
