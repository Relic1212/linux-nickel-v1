{
  lib,
  drvs,
  hyprlang | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprlang/archive/refs/tags/v0.6.7.tar.gz",
      sha256sum = "e8d54af895ec04fe99553c68d1255dceddb43723ada4a134acdd46bfe1dbf924",
    },
    pDrvs = [
      drvs.hyprutils,
    ],
    preConfigurePhase = [
      m%"
        sed -i \
          's@hyprlang SHARED@hyprlang STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%
    ]
  }
}
