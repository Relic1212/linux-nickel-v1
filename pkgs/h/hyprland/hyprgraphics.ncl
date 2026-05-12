{
  lib,
  drvs,
  hyprgraphics | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/hyprwm/hyprgraphics/archive/refs/tags/v0.5.1.tar.gz",
      sha256sum = "861ecaad872835922dd5745a612d7a4cc7bfc4babb1d06bc92bc63c2ac013b74",
    },
    eofPatches = [
      {
        patch = import "hyprgraphics-0.5.1-no-svg.patch" as 'Text
      },
    ],

    # patches = [
    #   {
    #     sha256sum = "84097f3c9db4e5dc5482624c4e0ced9a1d6175b4a1c8408b1515b0fbb0f1e9ae",
    #     file = "hyprgraphics-no-svg.patch"
    #   }
    # ],
    biDrvs = [
      # drvs.libdrm,
      # drvs.libpciaccess,
      drvs.pixman,
      drvs.expat,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      # drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.hyprwaylandScanner,
      drvs.aquamarine,
      drvs.hyprutils,
      drvs.hyprlang,
      drvs.hyprcursor,
      drvs.libjpegTurboStatic,
      drvs.libspng,
      drvs.file,
      drvs.libwebp,
      drvs.fribidi,
      drvs.pcre2,
    ],
    pDrvs = [
      drvs.mesa2,
    ],
    preConfigurePhase = [
      "sed -i 's@hyprgraphics SHARED@hyprgraphics STATIC@g' ${SRC}/CMakeLists.txt",
      "sed -i 's@find_package(OpenGL@# find_package(OpenGL@g' ${SRC}/CMakeLists.txt",
      "rm ${SRC}/src/image/formats/Svg.cpp",
      "rm ${SRC}/src/image/formats/Svg.hpp",
    ]
  }
}
