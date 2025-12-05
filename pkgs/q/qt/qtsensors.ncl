{
  lib,
  drvs,
  qtsensors | lib.QtPackage = {
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
      drvs.pyyaml,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.dbusForQt,
      drvs.qtbase,
      drvs.qtdeclarative,
      drvs.qtshadertools,
      drvs.qtsvg,

      ###
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.libxkbcommon,
      drvs.openssl,

      #drvs.gnumake,
      drvs.kmod,
      drvs.zstd,
      drvs.xz,
      drvs.eudev,
      drvs.libinput,
      drvs.fontconfig,
      drvs.freetype,
      drvs.harfbuzzFull,
      drvs.cairo,
      drvs.pixman,
      drvs.libpng,
      drvs.glib,
    ],

    # buildEnv = {
    #   EXTRA_LDFLAGS = [
    #     "$(pkg-config --libs --static gbm glesv2 dri egl)",
    #   ]
    # },

    # cmakeExtraArgsRecord = {

    #   "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    # },
  }
}
