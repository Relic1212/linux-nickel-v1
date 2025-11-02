{
  lib,
  drvs,
  pythonFlitCore | lib.Package = {
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/source/f/flit/flit-3.9.0.tar.gz",
      sha256sum = "d75edf5eb324da20d53570a6a6f87f51e606eee8384925cd66a90611140844c7"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonInstaller,
      drvs.pythonSetuptools,
    ],
    buildDir = "${SRC}",
    buildPhase = [
      "rm -rf flit_core/flit_core/vendor",
      "python flit_core/build_dists.py",
    ],
    installPhase = [
      "python -m installer -d ${DEST} flit_core/dist/flit_core-3.9.0-py3-none-any.whl"
    ],
  },

  pythonFlitCore312 | lib.Package = {
    singleSource = {
      uri = "https://github.com/pypa/flit/archive/refs/tags/3.12.0.tar.gz",
      sha256sum = "c157ff92c01f4bb169182722ff76aadac113926b729215e91909021aa56e2ea3"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonInstaller,
      drvs.pythonSetuptools,
    ],
    buildDir = "${SRC}",
    buildPhase = [
      "python flit_core/build_dists.py",
    ],
    installPhase = [
      "python -m installer -d ${DEST} flit_core/dist/flit_core-*-py3-none-any.whl"
    ],
  }
}
