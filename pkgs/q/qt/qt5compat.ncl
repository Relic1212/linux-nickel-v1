{
  lib,
  drvs,
  qt5compat | lib.QtPackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.qtbaseVulkan,
    ],

    # buildEnv = {
    #   EXTRA_LDFLAGS = [
    #     "$(pkg-config --libs --static gbm glesv2 dri egl)",
    #   ]
    # },
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    },
  }
}
