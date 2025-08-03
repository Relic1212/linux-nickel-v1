{
  lib,
  drvs,
  qtsvg | lib.QtPackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://download.qt.io/archive/qt/6.9/6.9.1/submodules/qtsvg-everywhere-src-6.9.1.tar.xz",
      sha256sum = "2dfc5de5fd891ff2afd9861e519bf1a26e6deb729b3133f68a28ba763c9abbd5"
    },
    llvmProvider = drvs.llvmFull,
    symlinkBuldInputs = true,

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
    ],

    buildEnv = {
      # EXTRA_LDFLAGS = [
      #   "$(pkg-config --libs --static gbm glesv2 dri egl)",
      # ]
    },

    symlinkBuldInputs = true,
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\"",
      "-DQT_QPA_DEFAULT_PLATFORM" = "wayland",

      "-DQT_QPA_PLATFORMS" = "wayland",
      "-DINSTALL_QMLDIR" = "/usr/lib/qt6/qml",
      "-DINSTALL_PLUGINSDIR" = "/usr/lib/qt6/plugins",
    },
  }
}
