{
  lib,
  drvs,
  hyprwire | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprwire/archive/refs/tags/v0.3.1.tar.gz",
      sha256sum = "92a673d40ae6a7d66fbcd0a34ec071e026e17eaeeb0040c3375e4b2a80dba737",
    },
    cmakeExtraArgsRecord = {
      "-DBUILD_TESTING" = false,
    },
    preConfigurePhase = [
      "sed -i 's|SHARED|STATIC|g' ${SRC}/CMakeLists.txt",
      m%"sed -i "s@#include <cstring>@#include <cstring>\n#include <array>@g" ${SRC}/src/core/message/messages/Hello.cpp"%,
    ],
    biDrvs = [
      drvs.pugixml,
      drvs.hyprutils,
      drvs.libffi,
    ]
  }
}
