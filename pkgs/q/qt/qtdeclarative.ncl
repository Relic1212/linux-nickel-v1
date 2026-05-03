{
  lib,
  drvs,
  qtdeclarative | lib.QtPackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pythonFull,
    ],
    pDrvs = [
      drvs.qtsvg,
      drvs.qtshadertools,
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        #   "$(pkg-config --libs --static gbm glesv2 dri egl)",
        "$(pkg-config --libs --static glib-2.0 gmodule-2.0 fontconfig)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_QPA_DEFAULT_PLATFORM" = "wayland",

      "-DQT_QPA_PLATFORMS" = "wayland",
      "-DINSTALL_QMLDIR" = "/usr/lib/qt6/qml",
      "-DINSTALL_PLUGINSDIR" = "/usr/lib/qt6/plugins",

      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl glib-2.0 gmodule-2.0)\""
    },
  }
}
