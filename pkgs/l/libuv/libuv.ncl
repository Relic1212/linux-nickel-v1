{
  lib,
  drvs,
  libuv | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libuv/libuv/archive/refs/tags/v1.51.0.tar.gz",
      sha256sum = "27e55cf7083913bfb6826ca78cde9de7647cded648d35f24163f2d31bb9f51cd",
    },
    cmakeExtraArgsRecord = {
      "-DLIBUV_BUILD_SHARED" = false,
    }
  }
}
