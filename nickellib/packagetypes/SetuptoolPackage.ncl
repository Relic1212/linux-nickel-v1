{
  drvs,
  lib = {
    Package,

    SetuptoolPackage =
      Package
      & {
        stage,
        pythonExecutable | String | default = "python",
        buildPhase | priority -5 = [
          "cd ${SRC}",
          "%{pythonExecutable} setup.py build",
        ],
        installPhase | priority -5 = [
          "%{pythonExecutable} setup.py install --prefix=/usr --root=${DEST} --skip-build"
        ],
        enableCcache | priority -1000 = false,
        pythonProvider | default = drvs.pythonFull,
        baseBuildinputPackages | priority -1000 =
          Package.baseBuildinputPackages
          @ (
            if (stage == -1) then
              (
                [
                  pythonProvider,
                  # drvs.pkgconf,
                  # drvs.musl,
                  drvs.pythonSetuptools,
                ]
                # @ (if isLlvm then [drvs.llvm] else [])
                @ (if enableCcache then [drvs.ccacheBin, drvs.ccacheSymlinks] else [])
              )
            else
              []
          ),
      },
  }
}
& {
  drvs,
  lib = {
    Package,
    gpepPackage =
      Package
      & {
        separateBuildDir | priority -1000 = false,
        buildPhase | priority -1000 = [
          "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
        ],

        installPhase | priority -1000 = [
          "python -m installer -d ${DEST} .dist/*.whl",
        ],
        # biDrvs = [
        #   drvs.pythonFull,
        #   drvs.pythonSetuptools80,
        #   drvs.pythonInstaller,
        #   drvs.pythonGpep517,
        #   # drvs.pythonFlitCore,
        #   # drvs.pythonHatchling,
        #   # drvs.pythonPathspec,
        #   # drvs.pythonPluggy,
        #   # drvs.pythonImportlibMetadate,
        #   # drvs.pythonMako,
        #   # drvs.pythonPackaging,
        #   # drvs.pythonMarkupsafe,
        #   # drvs.pythonTroveClassifiers,
        #   # drvs.pythonHatchFancy,
        # ],

        stage,
        pythonProvider | default = drvs.pythonFull,

        enableCcache,

        baseBuildinputPackages | priority -1000 =
          Package.baseBuildinputPackages
          @ (
            if (stage == -1) then
              (
                [
                  pythonProvider,
                  drvs.pythonSetuptools80,
                  drvs.pythonInstaller,
                  drvs.pythonGpep517,
                ]
                # @ (if isLlvm then [drvs.llvm] else [])
                @ (if enableCcache then [drvs.ccacheBin, drvs.ccacheSymlinks] else [])
              )
            else
              []
          ),
      }
  }
}
