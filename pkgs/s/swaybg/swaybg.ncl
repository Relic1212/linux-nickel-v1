{
  lib,
  drvs,
  swaybg | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/swaywm/swaybg/releases/download/v1.2.1/swaybg-1.2.1.tar.gz",
      sha256sum = "6af1fdf0e57b1cc5345febed786b761fea0e170943a82639f94cfaed7df84f8f"
    },
    biDrvs = [
      drvs.gdkPixbufFull,
      drvs.libpng,
      drvs.libjpegTurbo,
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.pixman,
      drvs.freetype,
      drvs.fontconfig,
      drvs.expat,
      drvs.cairo,
      drvs.scdoc,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.linuxHeaders,
    ],
  }
}
