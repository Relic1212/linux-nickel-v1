{
  lib,
  drvs,
  pythonMaturin | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/PyO3/maturin/archive/refs/tags/v1.15.0.tar.gz",
      sha256sum = "623111bddb2d7f6f4ba2e64038f91f8b673bd6f95dd6fcbaf334b7af7789b48d",
    },
    preConfigurePhase = [
      "export HOME=/tmp/home",
      "mkdir ${HOME}",
    ],
    biDrvs = [
      drvs.pythonSetuptoolsRust,
      drvs.pythonPuccinialin,
      drvs.pythonFilelock,
    ],
  }
}
