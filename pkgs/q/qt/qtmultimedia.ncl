{
  lib,
  drvs,
  qtmultimedia | lib.QtPackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://download.qt.io/archive/qt/6.9/6.9.1/submodules/qtmultimedia-everywhere-src-6.9.1.tar.xz",
      sha256sum = "955e36459518ee55f8e2bb79defc6e44aa94dc1edf5ac58a22d7734b2e07391d"
    },
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
    # cmakeExtraArgsRecord = {
    #   "-DQT_DEBUG_FIND_PACKAGE" = "ON",
    #   # "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    #   "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",
    # },
  }
}
