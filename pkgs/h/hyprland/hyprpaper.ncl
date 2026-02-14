{
  lib,
  drvs,
  hyprpaper | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprpaper/archive/refs/tags/v0.7.6.tar.gz",
      sha256sum = "a19f59e21abb8b1e3f4103ffeeac7c4658c1c09433047979836b2210a4edc40e",
    },
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
      drvs.hyprutils,
      drvs.hyprlang,
      drvs.hyprcursor,
      drvs.libjpegTurboStatic,
      drvs.libspng,
      drvs.file,
      drvs.libwebp,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.hyprgraphics,
      drvs.pcre2,
      drvs.fribidi,
    ],
    preConfigurePhase = [
      "sed -i 's@#include <GLES3/gl32.h>@@g' ${SRC}/src/includes.hpp",
      "sed -i 's@#include <GLES3/gl3ext.h>@@g' ${SRC}/src/includes.hpp",
      "sed -i 's@OpenGL@@g' ${SRC}/CMakeLists.txt",
      "sed -i 's@GLESv2@@g' ${SRC}/CMakeLists.txt",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-ljpeg",
        "-lspng",
        "-lwebp",
      ]
    }
  }
}
