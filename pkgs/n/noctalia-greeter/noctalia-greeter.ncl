{
  lib,
  drvs,
  noctaliaGreeter | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/noctalia-greeter/archive/refs/tags/v1.7.0.tar.gz",
      sha256sum = "5b092784c0147bb6739efc2e8146d2d07e3572a59d7a370e93092f9f56d4fcc8",
    },
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
    },
    enableParallel = false,
    preConfigurePhase = [
      "sed -i 's@::xmlFree(raw);@xmlFree(raw);@g' ${SRC}/src/tools/passwordless_sync_policy_xml.cpp",
      m%"sed -i "s@#include <array>@#include <array>\n#include <algorithm>@g" ${SRC}/src/render/programs/rect_program.cpp"%,
      m%"sed -i "s@#include@#include <string>\n#include@g" ${SRC}/src/ui/controls/image.cpp"%,
    ],
    preBuildPhase = [
      # "ninja fractional-scale-v1-client-protocol.h viewporter-client-protocol.h cursor-shape-v1-client-protocol.h",
      "ninja xdg-shell-client-protocol.h cursor-shape-v1-client-protocol.h fractional-scale-v1-client-protocol.h viewporter-client-protocol.h",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # drvs.libxml2,
    ],
    pDrvs = [
      # drvs.wayland,
      # drvs.waylandProtocols,

      # drvs.libxkbcommon,
      # drvs.freetype,
      # drvs.fontconfig,
      # drvs.cairo,
      # drvs.pango,
      drvs.librsvg,
      drvs.tomlplusplus,
      drvs.nlohmannJson,
      drvs.wlroots20,
      drvs.stb,
      drvs.libwebp,
      drvs.libjxl,
    ],
  }
}
