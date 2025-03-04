{
  lib,
  drvs,
  qtsensors | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://download.qt.io/archive/qt/6.8/6.8.2/submodules/qtsensors-everywhere-src-6.8.2.tar.xz",
        sha256sum = "8a817c9b001ad0abdbf15064826ca6a8ee6b66fef8f04b4343ac9f7b2ddbf4ca"
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
        drvs.pyyaml,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs.dbusForQt,
        drvs.qtbase,
        drvs.qtdeclarative,
                  drvs.qtshadertools,

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


        ],


    buildEnv = {
        EXTRA_LDFLAGS= [
                      "$(pkg-config --libs --static gbm glesv2 dri egl)",

        ]
    },


    cmakeExtraArgsRecord = {
 
        "-DCMAKE_MODULE_LINKER_FLAGS:STRING"="\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },


    }
}
