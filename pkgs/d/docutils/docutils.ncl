{
  lib,
  drvs,
  docutils | lib.Package = {
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/e9/86/5b41c32ecedcfdb4c77b28b6cb14234f252075f8cdb254531727a35547dd/docutils-0.22.tar.gz",
      sha256sum = "ba9d57750e92331ebe7c08a1bbf7a7f8143b86c476acd51528b042216a6aad0f"
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
