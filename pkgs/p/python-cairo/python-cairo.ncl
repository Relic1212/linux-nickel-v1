{
  lib,
  drvs,
  pythonPycairo | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/pygobject/pycairo/archive/refs/tags/v1.28.0.tar.gz",
      sha256sum = "e7e1a487820467a174512633f3ec4c49d567041e40f2d0135d14679045b054e9"
    },
    isStatic = false,
    buildEnv._isStatic = false,
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      # drvs.binutils,
      # drvs.lddObjdump,
      drvs.bison,
      drvs.cairoGobject,
      drvs.expat,
      drvs.flex,
      drvs.fontconfig,
      drvs.freetype,
      drvs.glibDynamic,
      drvs.gobjectDynamic,
      drvs.libffi,
      drvs.libpngPic,
      drvs.libtool,
      drvs.m4,
      drvs.muslShared,
      drvs.pcre2,
      drvs.pixman,
      drvs.pythonSetuptools,
      drvs.zlibNgPic,
    ]
  }
}
