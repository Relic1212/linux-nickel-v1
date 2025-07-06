{
  lib,
  gdkPixbufFull,
  libpng,
  libjpegTurbo,
  glib,
  pcre2,
  libffi,
  zlibNg,
  pixman,
  freetype,
  fontconfig,
  expat,
  cairo,
  scdoc,
  wayland,
  waylandProtocols,
  linuxHeaders,

  swaybg | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/swaywm/swaybg/releases/download/v1.2.1/swaybg-1.2.1.tar.gz",
      sha256sum = "6af1fdf0e57b1cc5345febed786b761fea0e170943a82639f94cfaed7df84f8f"
    },
    biDrvs =
      lib.biMap [
        gdkPixbufFull,
        libpng,
        libjpegTurbo,
        glib,
        pcre2,
        libffi,
        zlibNg,
        pixman,
        freetype,
        fontconfig,
        expat,
        cairo,
        scdoc,
        wayland,
        waylandProtocols,
        linuxHeaders,
      ],
  }
}
