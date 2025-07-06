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
  dbusForQt,
  qtbase,
  libxkbcommon,
  openssl,
  kmod,
  zstd,
  xz,
  eudev,
  libinput,
  llvmFull,

  qtshadertools | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qt/qtshadertools/archive/refs/tags/v6.8.2.tar.gz",
      sha256sum = "13d62df354ca2ca034d8a28263ee67104a6d94f5671417152556eb5eb3d64839"
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
        dbusForQt,
        ###
        qtbase,
        libxkbcommon,
        openssl,
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
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
  }
}
