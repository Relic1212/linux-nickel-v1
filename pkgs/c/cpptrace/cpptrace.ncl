{
  lib,
  drvs,
  cpptrace | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/jeremy-rifkin/cpptrace/archive/refs/tags/v1.0.4.tar.gz",
      sha256sum = "5c9f5b301e903714a4d01f1057b9543fa540f7bfcc5e3f8bd1748e652e24f9ea",
    },

    cmakeExtraArgsRecord = {
      "-DCPPTRACE_USE_EXTERNAL_LIBDWARF" = true,
      "-DCPPTRACE_USE_EXTERNAL_ZSTD" = true,
      "-DCPPTRACE_UNWIND_WITH_LIBUNWIND" = true,
    },
    biDrvs = [
      drvs.zstdCmake,
      drvs.libdwarf,
    ]
  }
}
