{
  lib,
  drvs,
  pythonUrllib3 | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/urllib3/urllib3/archive/refs/tags/2.8.0.tar.gz",
      sha256sum = "8a6c610573d257dcb8959e5e6448a5b2574ae8e2d4a9c2a9b40bde0f63a61e34",
    },
    preConfigurePhase = [
      "export HOME=/tmp/home",
      "mkdir \"${HOME}\"",
      "git config --global user.email \"you@example.com\"",
      "git config --global user.name \"Your Name\"",
      "git init",
      "git add .",
      "git commit -m 'initial commit'",
    ],
    biDrvs = [
      drvs.git,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonHatchVcs,
      drvs.pythonSetuptoolsScm,
      drvs.pythonTroveClassifiers,
    ],
  }
}
