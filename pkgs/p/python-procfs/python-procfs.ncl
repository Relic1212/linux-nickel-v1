{
  lib,
  drvs,
  pythonProcfs | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/pmuller/procfs/archive/refs/tags/0.5.0.tar.gz",
      sha256sum = "5f987c554e3b4c3ccb21b050190d71e2d5f19fec2f8f53586a62384dcf49c97a",
    }
  }
}
