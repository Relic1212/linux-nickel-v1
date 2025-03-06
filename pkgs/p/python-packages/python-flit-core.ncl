{
  lib,
  pkgs,
  pythonFlitCore | lib.Package = {
    name = "python-flit-core",
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/source/f/flit/flit-3.9.0.tar.gz",
      sha256sum = "d75edf5eb324da20d53570a6a6f87f51e606eee8384925cd66a90611140844c7"
    },
    biDrvs =
      lib.biMap [
        pkgs.pythonFull,
        pkgs.pythonInstaller,
        pkgs.pythonSetuptools,
      ],
    buildDir = "${SRC}",
    buildPhase = [
      "rm -rf flit_core/flit_core/vendor",
      "python flit_core/build_dists.py",
    ],
    installPhase = [
      "python -m installer -d ${DEST} flit_core/dist/flit_core-3.9.0-py3-none-any.whl"
    ],
  }
}
