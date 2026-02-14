{
  lib,
  drvs,
  hyprgraphics | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/hyprwm/hyprgraphics/archive/refs/tags/v0.4.0.tar.gz",
      sha256sum = "1ee818778eafd36919a463481fe0838ea3440d53fbd2305a5bf1449c61148678",
    },

    patches = [
      {
        sha256sum = "84097f3c9db4e5dc5482624c4e0ced9a1d6175b4a1c8408b1515b0fbb0f1e9ae",
        file = "hyprgraphics-no-svg.patch"
      }
    ],
    biDrvs = [
      drvs.pixman,
      drvs.expat,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.hyprwaylandScanner,
      drvs.aquamarine,
      drvs.hyprUtils,
      drvs.hyprlang,
      drvs.hyprcursor,
      drvs.libjpegTurboStatic,
      drvs.libspng,
      drvs.file,
      drvs.libwebp,
      drvs.fribidi,
      drvs.pcre2,
    ],
    preConfigurePhase = [
      "sed -i 's@hyprgraphics SHARED@hyprgraphics STATIC@g' ${SRC}/CMakeLists.txt"
    ]
  }
}
