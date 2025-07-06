{
  lib,
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
  pythonFull,
  libxkbcommon,
  kmod,
  zstd,
  xz,
  eudev,
  libinput,
  llvmFull,
  qtdeclarative | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qt/qtdeclarative/archive/refs/tags/v6.8.2.tar.gz",
      sha256sum = "1c29e98fac88f6d3b8a790248f4e6ad80439fe6e791116339d080e064ad8ae91"
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
        pythonFull,
        libxkbcommon,
        kmod,
        zstd,
        xz,
        eudev,
        libinput,
      ]
      @ [
        #cmake,
        #samurai,
        #pkgconf,
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
