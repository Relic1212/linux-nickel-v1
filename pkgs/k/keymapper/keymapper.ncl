{
  lib,
  drvs,
  keymapper | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/houmain/keymapper/archive/refs/tags/5.5.1.tar.gz",
      sha256sum = "379f7353a42b690322db69a0500999e465d149176715de4f2cd1aa050b67330c",
    },
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.libusb,
    ],
  }
}
