{
  lib,
  drvs,
  qtwayland | lib.QtPackage = {
    generator = "Ninja",
    # singleSource = {
    #   uri = "https://github.com/qt/qtwayland/archive/refs/tags/v6.9.1.tar.gz",
    #   sha256sum = "735bced5fc1ab11e3c3b6cc3ca321f148d2fe80675a2a27b41ddbd372ca4e6ea"
    # },

    # buildEnv = {
    #   EXTRA_LDFLAGS = [
    #     "$(pkg-config --libs --static gbm glesv2 dri egl)",
    #   ]
    # },

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
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.qtdeclarative,
    ],
  }
}
