{
  lib,
  drvs,

  pythonSetuptools | lib.SetuptoolPackage = {
    name = "python-setuptools",
    singleSource = {
      uri = "https://github.com/pypa/setuptools/archive/refs/tags/v75.1.0.tar.gz",
      sha256sum = "514dc60688d3118c9883a3dd54a38b28128ea912c01ea325d6e204a93da3b524",
    },
    pythonExecutable = "python3",
    utilsProviders = [],
    baseBuildinputPackages = [],

    buildInputs = [
      drvs.busybox,
      drvs.pythonFull,
    ]
  },
  pythonSetuptools80 | lib.SetuptoolPackage =
    pythonSetuptools
    & {
      singleSource | priority 1 = {
        uri = "https://github.com/pypa/setuptools/archive/refs/tags/v80.9.0.tar.gz",
        sha256sum = "06921ef18c10968ab35116603645c6e64cde851ff3886838d9c448db5329fe35"
      }
    }
}
