{
  lib,
  drvs,
  hyprutils | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprutils/archive/refs/tags/v0.11.0.tar.gz",
      sha256sum = "1f097eb9915081f1b929973701643bcd8581b469c242eae5446275b120a3b229",
    },
    biDrvs = [
      drvs.pixman,
    ],
    preConfigurePhase = [
      m%"
        sed -i \
          's@hyprutils SHARED@hyprutils STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%
    ]
  }
}
