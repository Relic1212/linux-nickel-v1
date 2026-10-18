{
  lib,
  drvs,
  pythonIgnis | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/ignis-sh/ignis/archive/refs/tags/v0.6.0.tar.gz",
      sha256sum = "b634a4c47450fb1f1897c8e1fcc2e914193bde03bf9bb03ac9335bb58009760c",
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
