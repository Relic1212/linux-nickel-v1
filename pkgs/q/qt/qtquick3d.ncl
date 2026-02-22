{
  lib,
  drvs,
  qtquick3d | lib.QtPackage = {
    generator = "Ninja",
    # singleSource = {
    #   uri = "https://github.com/qt/qtquick3d/archive/refs/tags/v6.9.1.tar.gz",
    #   sha256sum = "127ea0306c5ca1a67d90b13c8d60a21b8e52ade007853bac7bcbf55af61ae0db"
    # },
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
      drvs.glib,
      ### -font
    ],
    preConfigurePhase = [
      "sed -i 's@QUIET @@g' ${SRC}/CMakeLists.txt"
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 dri egl)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
  }
}
