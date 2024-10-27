{
  lib,
  pkgs,
  pythonJinja2 | lib.Package
    = {
      name = "python-jinja2",
      singleSource = {
        uri = "https://files.pythonhosted.org/packages/source/j/jinja2/jinja2-3.1.4.tar.gz",
        sha256sum = "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369",
      },
      buildPhase = [
        "cd ${SRC}",
        "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
        "python -m installer -d ${DEST} .dist/*.whl",
      ],
      biPkgs = [
        pkgs.pythonFull,
        pkgs.pythonSetuptools,
        pkgs.pythonInstaller,
        pkgs.pythonGpep517,
        pkgs.pythonFlitCore,
      ]
    }
}
