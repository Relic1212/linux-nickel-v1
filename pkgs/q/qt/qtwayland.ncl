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
  qtdeclarative,
  qtshadertools,
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

  qtwayland | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qt/qtwayland/archive/refs/tags/v6.8.2.tar.gz",
      sha256sum = "74d4f8ad98f86958c2d34c416ae24ad58d5b1c6b2361e63c0676db9d753b1f30"
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
        qtbase,
        qtdeclarative,
        qtshadertools,

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

    # TODO: investigae these
    #     FEATURE_egl_extension_platform_wayland:BOOL=OFF
    # 304:FEATURE_wayland_brcm:BOOL=OFF
    # 333:FEATURE_wayland_decoration_adwaita:BOOL=OFF
    # 336:FEATURE_wayland_dmabuf_client_buffer:BOOL=OFF
    # 339:FEATURE_wayland_dmabuf_server_buffer:BOOL=OFF
    # 342:FEATURE_wayland_drm_egl_server_buffer:BOOL=OFF
    # 345:FEATURE_wayland_egl:BOOL=OFF
    # 348:FEATURE_wayland_layer_integration_vsp2:BOOL=OFF
    # 351:FEATURE_wayland_libhybris_egl_server_buffer:BOOL=OFF
    # 360:FEATURE_wayland_vulkan_server_buffer:BOOL=OFF

    cmakeExtraArgsRecord = {
      "-DFEATURE_wayland_compositor_quick" = "ON",
      "-DFEATURE_wayland_egl" = "ON",
      "-DQT_FEATURE_egl" = "ON",
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },

    preConfigurePhase = [
      "sed -i 's@QUIET @@g' ${SRC}/CMakeLists.txt"
    ],
  }
}
