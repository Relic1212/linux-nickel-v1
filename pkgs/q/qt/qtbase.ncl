{
  lib,
  drvs,
  pkgs,
  qtbase | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/qt/qtbase/archive/refs/tags/v6.8.0.tar.gz",
        sha256sum = "3e526ceaaf615005bc89a98ee8a52b87db6fefe7155595bf75c40fd82cd1a7ce"
      },
      llvmProvider = pkgs.llvmFull,

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
      ]
    }
}
