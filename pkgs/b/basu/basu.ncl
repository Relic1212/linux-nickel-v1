{
  lib,
  drvs,
  basu | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~emersion/basu/refs/download/v0.2.1/basu-0.2.1.tar.gz",
      sha256sum = "d9b373a9fcb5d5eb5f6c1c56355f76edb7f2f52bc744570e80604e83455a19bd",
    },
    biDrvs = [
      drvs.gperf,
      drvs.muslGetent,
    ]
  }
}
