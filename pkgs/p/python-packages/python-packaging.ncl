{
  lib,
  drvs,
  pythonPackaging | lib.Package = {
    # name = "python-packaging",
    singleSource = {
      uri = "https://github.com/pypa/packaging/archive/24.1/python-packaging-24.1.tar.gz",
      sha256sum = "7b31090ae4ddd6c48a5ed10073a880e6e2612ce8ac2f81e34f42aaabefd1b81b",
    },
    biDrvs = [
      drvs.pythonGpep517,
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonFlitCore,
    ],
    buildDir = "${SRC}",
    installPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
      "python -m installer -d  ${DEST} .dist/*.whl",
    ]
  },
  pythonPackaging242 =
    pythonPackaging
    & {
      singleSource | priority 1 = {
        uri = "https://github.com/pypa/packaging/archive/24.2/python-packaging-24.2.tar.gz",
        sha256sum = "c448ea78de5134f5002a2aa2bb62a0fb4714bb4ab2d2b00bce8ed6ca22502d5a",
      },
    }
}
