{
  lib,
  drvs,
  btop | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.4.tar.gz",
      sha256sum = "98d464041015c888c7b48de14ece5ebc6e410bc00ca7bb7c5a8010fe781f1dd8",

      # uri = "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.7.tar.gz",
      # sha256sum = "933de2e4d1b2211a638be463eb6e8616891bfba73aef5d38060bd8319baeefc6",
    },

    cmakeExtraArgsRecord = {
      "-DBTOP_LTO" = false,
    },

    preConfigurePhase = [
      # m%"sed -i 's@@@g' ${SRC}/include/fmt/format.h"%,
      m%"sed -i "s@#include \"base.h\"@#include \"base.h\"\n#include <cstdlib>@g" ${SRC}/include/fmt/format.h"%,
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
