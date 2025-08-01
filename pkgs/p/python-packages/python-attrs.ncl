{
  lib,
  drvs,
  pythonAttrs | lib.Package = {
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz",
      sha256sum = "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
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
      drvs.pythonFlitCore,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
      drvs.pythonHatchFancy,
    ]
  }
}
& {
  lib,
  drvs,
  pythonHatchFancy | lib.Package = {
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz",
      sha256sum = "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
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
      drvs.pythonFlitCore,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging242,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
    ]
  }
}
