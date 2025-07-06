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
  git,
  pyyaml,
  llvmConfigStatic,
  spirvTools,
  spirvLlvmTranslator,
  openssl,
  dbusForQt,
  qtbase,
  qtshadertools,
  qtdeclarative,
  pythonFull,
  libxkbcommon,
  kmod,
  zstd,
  xz,
  eudev,
  libinput,
  llvmFull,

  qtquick3d | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qt/qtquick3d/archive/refs/tags/v6.8.2.tar.gz",
      sha256sum = "2901927d84fa3e55cd598575fa8a47dd97c770ed3c1893af9c9ee2aa167b7433"
    },
    llvmProvider = lib.singleBiMap llvmFull,

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
        git,
        pyyaml,
        llvmConfigStatic,
        spirvTools,
        spirvLlvmTranslator,
        openssl,
        ###
        dbusForQt,
        qtbase,
        qtshadertools,
        qtdeclarative,
        pythonFull,
        libxkbcommon,
        kmod,
        zstd,
        xz,
        eudev,
        libinput,
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
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
  }
}
