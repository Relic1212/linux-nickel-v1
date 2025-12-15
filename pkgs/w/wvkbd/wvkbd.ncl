{
  lib,
  drvs,
  wvkbd | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/jjsullivan5196/wvkbd/archive/refs/tags/v0.18.tar.gz",
      sha256sum = "4cd4e32490fba7913a9053645ce2a8d453c596bb3dd780631b8656d746327de6"
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.bison,
      drvs.m4,
      drvs.libxml2,
      drvs.libxkbcommon,
      drvs.pkgconfMeson,
      drvs.glib,
      drvs.pcre2,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.cairo,
      drvs.pixman,
      drvs.libpng,
      drvs.expat,
      drvs.fribidi,
      drvs.pango,
      drvs.scdoc,
      drvs.linuxHeaders,
    ]
  }
}
