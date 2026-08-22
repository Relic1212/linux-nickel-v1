{
  lib,
  drvs,
  libcapNg | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v0.9.5.tar.gz",
      sha256sum = "a2b4211f59b231d607c61ea2a13e9ecb38f446fe769b44e12da939d5af6d978a",
    },
    preConfigurePhase = [
      "touch ${SRC}/NEWS",
      m%"sed -i "s@#include <sys/cdefs.h>@// #include <sys/cdefs.h>@g" ${SRC}/utils/gcc-attributes.h"%,
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
  }
}
