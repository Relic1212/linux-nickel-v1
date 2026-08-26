{
  lib,
  drvs,
  pythonBuild | lib.Package = {
    singleSource = {
      uri = "https://github.com/pypa/build/archive/refs/tags/1.3.0.tar.gz",
      sha256sum = "fd7a275d4b34e2b5b4c73fb57ae3c8239b54e4d09752eb540d4167c77bfa043d"
    },
    buildPhase = [
      "cd ${SRC}",
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
      "python -m installer -d ${DEST} .dist/*.whl",
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore312,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
    ]
  }
}
