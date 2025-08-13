{
  lib,
  drvs,
  pythonPly | lib.Package = {
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz",
      sha256sum = "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3",
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
    ]
  }
}
