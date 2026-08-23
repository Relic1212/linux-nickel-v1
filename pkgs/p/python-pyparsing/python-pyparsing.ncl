{
  lib,
  drvs,
  pythonPyparsing | lib.Package = {
    singleSource = {
      uri = "https://github.com/pyparsing/pyparsing/archive/refs/tags/3.2.0.tar.gz",
      sha256sum = "91f52e4e06a2ee736531a3038fc2c7d6bb83f321831435fcedc14f95749c86ac"
    },
    separateBuildDir = false,
    buildPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
    ],
    installPhase = [
      "python -m installer -d ${DEST} .dist/*.whl",
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
    ]
  }
}
