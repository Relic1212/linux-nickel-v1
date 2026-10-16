{
  lib,
  drvs,
  pythonLinuxProcfs | lib.gpepPackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/python-linux-procfs.git/snapshot/python-linux-procfs-0.7.4.tar.gz",
      sha256sum = "2ad5ce9e710400686570f482804aa888b81059befe6db9c4dfe5cf39113ebdfa",
    },
  }
}
