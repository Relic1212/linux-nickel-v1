{
  lib,
  drvs,
  pythonPygobject | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/pygobject/3.52/pygobject-3.52.3.tar.gz",
      sha256sum = "00e427d291e957462a8fad659a9f9c8be776ff82a8b76bdf402f1eaeec086d82",
    },
    isStatic = false,
    buildEnv._isStatic = false,
    extraMesonArgs = [
      "-Dtests=false",
      # "-Dpycairo=disabled",
    ],
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.pythonSetuptools,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNgPic,
      drvs.glibDynamic,
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.libtool,
      drvs.cairoGobject,
      drvs.pixman,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpngPic,
      drvs.expat,
      drvs.muslShared,
      # drvs.binutils,
      # drvs.lddObjdump,
      drvs.gobjectDynamic,
      drvs.pythonPycairo,
    ]
  }
}
& {
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
