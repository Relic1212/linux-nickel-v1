{
  lib,
  drvs,
  pythonPoetry | lib.Package = {
    singleSource = {
      uri = "https://github.com/python-poetry/poetry/archive/refs/tags/2.5.1.tar.gz",
      sha256sum = "8bd6b01d549d864877ada791b3fcf299fc64a4d24a3d81463c8d1591f36023a9",
    },
    separateBuildDir = false,
    buildPhase = [
      "python -m build --wheel --no-isolation",
    ],
    installPhase = [
      "python -m installer -d ${DEST} dist/*.whl",
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonBuild,
      drvs.pythonHooks,
      drvs.pythonPoetryCore,
      drvs.pythonPackaging,
      drvs.pythonInstaller,
    ],
  }
}
