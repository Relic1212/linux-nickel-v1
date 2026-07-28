{
  lib,
  drvs,
  libyuv | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://chromium.googlesource.com/libyuv/libyuv",
      sha256sum = "b56492e2dfc064f65ef27fed9c45d9bbfc2e2ad2",
      fetchMethod = "git",
    },

    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      lib.functions.writeFile "${DEST}/usr/lib/pkgconfig/libyuv.pc" (import "libyuv.pc" as 'Text),
    ],
  }
}
