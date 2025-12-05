{
  lib,
  drvs,
  flashrom | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/flashrom/flashrom/archive/refs/tags/v1.6.0.tar.gz",
      # sha256sum = "735c077ee8ac08e236ef7b7db894ab22d5f4b75f10156a4732bd818a1e21fcc5",

      uri = "https://chromium.googlesource.com/chromiumos/third_party/flashrom.git",
      sha256sum = "0d20bd46f1bf2f11a33d817f01937fe0071a15bc",
      fetchMethod = "git"
    },
    biDrvs = [
      drvs.eudev,
      drvs.glib,
      drvs.gperf,
      drvs.jansson,
      drvs.kmod,
      drvs.libffi,
      drvs.libusb,
      drvs.linuxHeaders,
      drvs.openssl,
      drvs.pciutils,
      drvs.pcre2,
      drvs.utilLinux,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
    ]
  }
}
