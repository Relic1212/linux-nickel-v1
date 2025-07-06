{
  lib,
  mesa2,
  pkgconf,
  libelf,
  libdrm,
  zlibNg,
  pythonMako,
  pythonPackaging,
  pythonMarkupsafe,
  libpciaccess,
  libffi,
  bison,
  flex,
  wayland,
  waylandProtocols,
  linuxHeaders,
  m4,
  pyyaml,
  llvmConfigStatic,
  spirvTools,
  spirvLlvmTranslator,
  dbusForQt,
  qtbase,
  qtdeclarative,
  qtshadertools,
  qtsvg,
  expat,
  jsonC,
  pcre2,
  libxkbcommon,
  openssl,
  kmod,
  zstd,
  xz,
  eudev,
  libinput,
  llvmFull,

  qtsensors | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://download.qt.io/archive/qt/6.8/6.8.2/submodules/qtsensors-everywhere-src-6.8.2.tar.xz",
      sha256sum = "8a817c9b001ad0abdbf15064826ca6a8ee6b66fef8f04b4343ac9f7b2ddbf4ca"
    },
    llvmProvider = lib.singleBiMap llvmFull,
    symlinkBuldInputs = true,

    biDrvs =
      lib.biMap [
        mesa2,
        # pkgconf,
        libelf,
        libdrm,
        zlibNg,
        pythonMako,
        pythonPackaging,
        pythonMarkupsafe,
        libpciaccess,
        libffi,
        bison,
        flex,
        wayland,
        waylandProtocols,
        linuxHeaders,
        m4,
        pyyaml,
        llvmConfigStatic,
        spirvTools,
        spirvLlvmTranslator,
        dbusForQt,
        qtbase,
        qtdeclarative,
        qtshadertools,
        qtsvg,

        ###
        expat,
        jsonC,
        pcre2,
        libxkbcommon,
        openssl,

        #gnumake,
        kmod,
        zstd,
        xz,
        eudev,
        libinput,
      ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 dri egl)",
      ]
    },

    cmakeExtraArgsRecord = {

      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
  }
}
