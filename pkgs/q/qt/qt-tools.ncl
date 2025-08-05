{
  lib,
  drvs,
  qtTools | lib.QtPackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/qt/qttools/archive/refs/tags/v6.8.2.tar.gz",
      # sha256sum = "ead70f80f197fd746a5cbf57a8a2be6537cb0015a48361f108aa7e36d5a982fe",
      uri = "https://download.qt.io/archive/qt/6.9/6.9.1/submodules/qttools-everywhere-src-6.9.1.tar.xz",
      sha256sum = "90c4a562f4ccfd043fd99f34c600853e0b5ba9babc6ec616c0f306f2ce3f4b4c"
    },
    llvmProvider = drvs.llvmFull,
    symlinkBuldInputs = true,

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
      # "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",
    },
  }
}
