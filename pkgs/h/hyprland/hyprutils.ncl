{
  lib,
  drvs,
  hyprutils | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprutils/archive/refs/tags/v0.13.1.tar.gz",
      sha256sum = "480ee026105deea64a24eb96d80cabe54b357594ce36cb05c021ea226c69aede",
    },
    pDrvs = [
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
