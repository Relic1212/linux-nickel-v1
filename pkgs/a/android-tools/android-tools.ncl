{
  lib,
  drvs,
  androidTools | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/nmeum/android-tools/archive/refs/tags/35.0.2.tar.gz",
      # sha256sum = "048bd42b75166fa4b66989b25ba1abb2b773aa7b7d012d52d84010b127db8801",

      uri = "https://github.com/nmeum/android-tools/releases/download/35.0.2/android-tools-35.0.2.tar.xz",
      sha256sum = "d2c3222280315f36d8bfa5c02d7632b47e365bfe2e77e99a3564fb6576f04097"
    },
    buildEnv.EXTRA_LDFLAGS = ["-ludev"],
    biDrvs = [
      drvs.googletest,
      drvs.libusb,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.jansson,
      drvs.gperf,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.eudevForAndroidTools,
      drvs.lz4,
      drvs.protobuf,
      drvs.abseilCpp,
      drvs.brotli,
      drvs.fmt,
      drvs.linuxHeaders,
    ]
  }
}
& {
  eudev,
  lib,
  eudevForAndroidTools =
    eudev
    & {
      postInstallPhase | priority 1 =
        eudev.postInstallPhase
        @ [
          "llvm-objcopy --redefine-sym utf16_to_utf8=eudev__utf16_to_utf8 ${DEST}/usr/lib/libudev.a",
        ]
    }
}
