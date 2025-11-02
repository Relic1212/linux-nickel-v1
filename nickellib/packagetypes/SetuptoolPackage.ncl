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
                @ (if enableCcache then [drvs.ccacheBin] else [])
              )
            else
              []
          ),
      },
  }
}
