{
  lib,
  drvs,
  qtshadertools | lib.QtPackage = {
    generator = "Ninja",

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
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static fontconfig)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
    },
  }
}
