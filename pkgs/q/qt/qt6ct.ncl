{
  lib,
  drvs,
  qt6ct | lib.QtPackage = {
    singleSource = {
      uri = "https://www.opencode.net/trialuser/qt6ct/-/archive/0.11/qt6ct-0.11.tar.bz2",
      sha256sum = "c26bc87b8e1603e194f9793db58667722672a6c26dfc0e080a4b2afe35fe2583"
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs fontconfig)",
      ],
    },

    preConfigurePhase = [
      "sed -i 's@ SHARED@@g' ${SRC}/src/qt6ct-common/CMakeLists.txt",
      "sed -i 's@ MODULE@@g' ${SRC}/src/qt6ct-style/CMakeLists.txt",
      "sed -i 's@ MODULE@@g' ${SRC}/src/qt6ct-qtplugin/CMakeLists.txt",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.mesa2,
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
      drvs.qtTools,
    ],
  }
}
