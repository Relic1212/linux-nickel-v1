{
  lib,
  drvs,
  qtgraphicaleffects | lib.QtPackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qt/qtgraphicaleffects/archive/refs/tags/v5.15.17-lts-lgpl.tar.gz",
      sha256sum = "1c29e98fac88f6d3b8a790248f4e6ad80439fe6e791116339d080e064ad8ae91"
    },
    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
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
      @ [
        #drvs.cmake,
        #drvs.samurai,
        #drvs.pkgconf,
      ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        #   "$(pkg-config --libs --static gbm glesv2 dri egl)",
        "$(pkg-config --libs --static glib-2.0 gmodule-2.0)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_QPA_DEFAULT_PLATFORM" = "wayland",

      "-DQT_QPA_PLATFORMS" = "wayland",
      "-DINSTALL_QMLDIR" = "/usr/lib/qt6/qml",
      "-DINSTALL_PLUGINSDIR" = "/usr/lib/qt6/plugins",

      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl glib-2.0 gmodule-2.0)\""
    },
  }
}
