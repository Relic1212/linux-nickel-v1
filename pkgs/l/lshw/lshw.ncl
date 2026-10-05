{
  lib,
  drvs,
  lshw | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/lyonel/lshw/archive/refs/tags/B.02.20.tar.gz",
      sha256sum = "6b8346a89fb0f0f1798e66f6a707a881d38b9b3a67256b30fc4628dac09f291a"
    },

    extraMakeArgs = [
      "SBINDIR=/usr/bin"
    ],
    extraMakeInstallArgs = extraMakeArgs,

    preConfigurePhase = [
      m%"sed -i "s@#include <cstring>@#include <cstring>\n#include <cstdlib>@g" ${SRC}/src/core/spd.cc"%,
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.gettext,
      drvs.git,
    ],
  },

  lshwGui =
    lshw
    & {
      makeTargets = ["gui"]
    }
}
