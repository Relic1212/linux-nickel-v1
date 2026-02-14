{
  lib,
  drvs,
  muparser | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/beltoforion/muparser/archive/refs/tags/v2.3.5.tar.gz",
      sha256sum = "20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4",
    },
    cmakeExtraArgsRecord = {
      "-DENABLE_OPENMP" = false,
    },
  }
}
