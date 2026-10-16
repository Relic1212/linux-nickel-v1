{
  lib,
  drvs,
  pythonPsutil | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/giampaolo/psutil/archive/refs/tags/v7.2.2.tar.gz",
      sha256sum = "fb49da760f2eda16205830653768fc8027fc86c68996d88b57134122aa08f7a1",
    },
    biDrvs = [
      drvs.musl,
      drvs.llvm,
      drvs.linuxHeaders,
    ]
  }
}
