{
  lib,
  drvs,
  liblogging | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/rsyslog/liblogging/archive/refs/tags/v1.0.7.tar.gz",
      sha256sum = "f0f6e82c57a47f71ccdf9673af9f317c37357c9113b865d9ef4e89c2238a3a44"
    },
    separateBuildDir = false,
    biDrvs = [
      drvs.pythonFull,
      drvs.docutils,
    ]
  }
}
