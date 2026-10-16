{
  lib,
  drvs,
  pythonFilelock | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/tox-dev/filelock/archive/refs/tags/4.2.0.tar.gz",
      sha256sum = "3210bc46a82cc4461511a4f9d57188ea33927b3817490ceaca49d12c6882da6b",
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
      drvs.pythonHatchVcs, # fixes "hatchling.plugin.exceptions.UnknownPluginError: Unknown version source: vcs"
      drvs.pythonSetuptoolsScm,
      drvs.pythonTroveClassifiers,
    ],
  }
}
