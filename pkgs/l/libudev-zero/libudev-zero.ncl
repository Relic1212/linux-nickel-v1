{
  lib,
  pkgs,
  libudevZero | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/illiliti/libudev-zero/archive/refs/tags/1.0.3.tar.gz",
      sha256sum = "0bd89b657d62d019598e6c7ed726ff8fed80e8ba092a83b484d66afb80b77da5",
    },
    # buildDir = "${SRC}",
    separateBuildDir = false,
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    makeInstallTargets = [
      "install-static"
    ],

    biDrvs =
      lib.biMap [
        pkgs.linuxHeaders,
      ]
  },
}
