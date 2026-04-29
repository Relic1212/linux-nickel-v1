{
  lib,
  drvs,
  libinputGestures | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/bulletmark/libinput-gestures/archive/refs/tags/2.81.tar.gz",
      sha256sum = "567c59bf15c26aa16fb7d079c76ad09eadb63aa8fde986c0e7a7091ced9589c2",
    },
    buildPhase = [],
    biDrvs = [
      drvs.bash,
      drvs.bashBinBash,
    ],

    utilsProviders = [
      drvs.coreutils,
      drvs.busybox
      & {
        priority = -1
      }
    ]
  }
}
