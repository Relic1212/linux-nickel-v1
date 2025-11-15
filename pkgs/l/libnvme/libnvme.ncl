{
  lib,
  drvs,
  libnvme | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/linux-nvme/libnvme/archive/refs/tags/v1.15.tar.gz",
      sha256sum = "c21cd9379390bdc52c9d9569a241274f8115fc247b76a5d922d639f48c8174a2"
    },
    biDrvs = [
      drvs.bash,
      drvs.linuxHeaders,
    ]
  }
}
