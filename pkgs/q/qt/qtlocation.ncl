{
  lib,
  drvs,
  qtlocation | lib.QtPackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.bison,
      drvs.cairo,
      drvs.dbusForQt,
      drvs.eudev,
      drvs.expat,
      drvs.flex,
      drvs.fontconfig,
      drvs.freetype,
      drvs.git,
      drvs.glib,
      drvs.harfbuzzFull,
      drvs.jsonC,
      drvs.kmod,
      drvs.libdrm,
      drvs.libelf,
      drvs.libffi,
      drvs.libinput,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.m4,
      drvs.mesa2,
      drvs.openssl,
      drvs.pcre2,
      drvs.perl,
      drvs.pixman,
      drvs.pythonMako,
      drvs.pythonMarkupsafe,
      drvs.pythonPackaging,
      drvs.pyyaml,
      drvs.qtbase,
      drvs.qtdeclarative,
      drvs.qtpositioning,
      drvs.qtshadertools,
      drvs.qtsvg,
      drvs.qtwayland,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      # "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",
    },
  }
}
