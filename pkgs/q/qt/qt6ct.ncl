{
  lib,
  drvs,
  qt6ct | lib.QtPackage = {
    singleSource = {
      uri = "https://github.com/trialuser02/qt6ct/releases/download/0.9/qt6ct-0.9.tar.xz",
      sha256sum = "0a9f00db7f9c2003b33fad1715cbf2a483bf50a99079b97bf8e5d0bdbd3392cd"
    },
    llvmProvider = drvs.llvmFull,
    symlinkBuldInputs = true,

    preConfigurePhase = [
      "sed -i 's@ SHARED@@g' ${SRC}/src/qt6ct-common/CMakeLists.txt",
      "sed -i 's@ MODULE@@g' ${SRC}/src/qt6ct-style/CMakeLists.txt",
      "sed -i 's@ MODULE@@g' ${SRC}/src/qt6ct-qtplugin/CMakeLists.txt",
    ],
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
      drvs.dbusForQt,
      ###
      drvs.qtbase,
      drvs.libxkbcommon,
      drvs.openssl,
      drvs.kmod,
      drvs.zstd,
      drvs.xz,
      drvs.eudev,
      drvs.libinput,
      drvs.perl,

      ### font
      drvs.fontconfig,
      drvs.freetype,
      drvs.harfbuzzFull,
      drvs.cairo,
      drvs.pixman,
      drvs.libpng,
      drvs.expat,
      drvs.glib,
      ### -font
      drvs.qtsvg,
    ],
  }
}
