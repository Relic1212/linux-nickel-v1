{
  lib,
  drvs,
  qcoro | lib.QtPackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qcoro/qcoro/archive/refs/tags/v0.12.0.tar.gz",
      sha256sum = "809afafab61593f994c005ca6e242300e1e3e7f4db8b5d41f8c642aab9450fbc"
    },
    cmakeExtraArgsRecord = {
      "-DUSE_QT_VERSION" = "6",
      "-DQCORO_WITH_QTWEBSOCKETS" = false,
      "-DQCORO_BUILD_TESTING" = false,
      "-DDQCORO_BUILD_EXAMPLES" = false,
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static expat glib-2.0 gmodule-2.0 )",
      ]
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
      drvs.openssl,
      ###
      drvs.dbusForQt,
      drvs.qtbase,
      drvs.qtshadertools,
      drvs.qtsvg,
      drvs.qtdeclarative,
      drvs.pythonFull,
      drvs.libxkbcommon,
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
      drvs.pcre2,
      ### -font
    ]
  }
}
