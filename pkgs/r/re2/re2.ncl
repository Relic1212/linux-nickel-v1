{
  lib,
  drvs,
  re2 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/re2/archive/refs/tags/2024-07-02.tar.gz",
      sha256sum = "eb2df807c781601c14a260a507a5bb4509be1ee626024cb45acbd57cb9d4032b"
    },
    biDrvs = [
      # drvs.pkgconf,
      drvs.abseilCpp,
    ]
  }
}
