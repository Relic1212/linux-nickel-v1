{
  lib,
  drvs,
  bzip2 | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.com/bzip2/bzip2/-/archive/66c46b8c9436613fd81bc5d03f63a61933a4dcc3/bzip2-66c46b8c9436613fd81bc5d03f63a61933a4dcc3.tar.gz",
      sha256sum = "3a4cff5f9d197e9e6c6138660afa6b1f9370df0bed135bd949243f6dfc83b3e1"
    },
    extraMesonArgs = [
      "-Ddocs=disabled",
    ],

    biDrvs = [
      drvs.pytest,
    ]
  }
}
& {

  lib,
  drvs,
  pytest | lib.Package = {
    singleSource = {
      uri = "https://github.com/pytest-dev/pytest/releases/download/8.3.3/pytest-8.3.3.tar.gz",
      sha256sum = "70b98107bd648308a7952b06e6ca9a50bc660be218d53c257cc1fc94fda10181"
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
