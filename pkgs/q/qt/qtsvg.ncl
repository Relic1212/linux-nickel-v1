{
    lib,
    drvs,
    qtsvg | lib.CmakePackage = {
        generator = "Ninja",
        singleSource = {
            uri = "https://download.qt.io/archive/qt/6.8/6.8.2/submodules/qtsvg-everywhere-src-6.8.2.tar.xz",
            sha256sum ="aa2579f21ca66d19cbcf31d87e9067e07932635d36869c8239d4decd0a9dc1fa"
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