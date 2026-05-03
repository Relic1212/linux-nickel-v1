{
  lib,
  drvs,
  qtsvg | lib.QtPackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.qtbaseVulkan,
    ],
    buildEnv = {
      # EXTRA_LDFLAGS = [
      #   "$(pkg-config --libs --static gbm glesv2 dri egl)",
      # ]
    },
    options.x11flags = true,

    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\"",
      "-DQT_QPA_DEFAULT_PLATFORM" = "wayland",

      "-DQT_QPA_PLATFORMS" = "wayland",
      "-DINSTALL_QMLDIR" = "/usr/lib/qt6/qml",
      "-DINSTALL_PLUGINSDIR" = "/usr/lib/qt6/plugins",
    },
  }
}
