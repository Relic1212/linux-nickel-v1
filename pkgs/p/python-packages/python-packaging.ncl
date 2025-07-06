{
  lib,
  pythonGpep517,
  pythonFull,
  pythonSetuptools,
  pythonInstaller,
  pythonFlitCore,

  pythonPackaging | lib.Package = {
    name = "python-packaging",
    singleSource = {
      uri = "https://github.com/pypa/packaging/archive/24.1/python-packaging-24.1.tar.gz",
      sha256sum = "7b31090ae4ddd6c48a5ed10073a880e6e2612ce8ac2f81e34f42aaabefd1b81b",
    },
    biDrvs =
      lib.biMap [
        pythonGpep517,
        pythonFull,
        pythonSetuptools,
        pythonInstaller,
        pythonFlitCore,
      ],
    buildDir = "${SRC}",
    installPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
      "python -m installer -d  ${DEST} .dist/*.whl",
    ]
  }
}
