{lib,
drvs,
qtshadertools | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/qt/qtshadertools/archive/refs/tags/v6.8.2.tar.gz",
        sha256sum = "13d62df354ca2ca034d8a28263ee67104a6d94f5671417152556eb5eb3d64839"
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
          ###
          drvs.qtbase,

            drvs.libxkbcommon,
        drvs.openssl,

        drvs.kmod,
        drvs.zstd,
        drvs.xz,
        drvs.eudev,
        drvs.libinput,

        ],


    buildEnv = {
        EXTRA_LDFLAGS= [
                      "$(pkg-config --libs --static gbm glesv2 dri egl)",

        ]
    },
    cmakeExtraArgsRecord = {
        "-DQT_DEBUG_FIND_PACKAGE"="ON",
        "-DCMAKE_MODULE_LINKER_FLAGS:STRING"="\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
        
    }
}