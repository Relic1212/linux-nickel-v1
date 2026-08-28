{
  lib,
  drvs,
  pythonPip | lib.Package = {
    singleSource = {
      uri = "https://github.com/pypa/pip/archive/refs/tags/26.2.1.tar.gz",
      sha256sum = "65cac79de403d368cc8333f3d9981f293248dc336662338749693ff99659d5e3",
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
      drvs.pythonFlitCore312, # flit_core.config.ConfigError: license field should be <class 'dict'>, not <class 'str'>
    ],
  },
}
