{
  lib,
  drvs,
  qtwayland | lib.CmakePackage
    = {
      # generator = "Ninja",
      singleSource = {
        uri = "https://github.com/qt/qtwayland/archive/refs/tags/v6.8.0.tar.gz",
        sha256sum = "c1828fd01273c2658e7307aed9549b00978815e70c94b40ceb9fdfb5243f1c20"
      },
      llvmProvider = drvs.llvmFull,

      biDrvs = [
        drvs.mesa2,
        # drvs.pkgconf,
        drvs.libelf,
        drvs.libdrm,
        drvs.zlibNg,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.libffi,
        drvs.bison,
        drvs.flex,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.linuxHeaders,
        drvs.m4,
        drvs.git,
        drvs.pyyaml,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs.qtbase,
        ###
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.libxkbcommon,
        drvs.gnumake,
      ]
    }
}
