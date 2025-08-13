{
  lib,
  drvs,
  pythonPygobject | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/pygobject/3.52/pygobject-3.52.3.tar.gz",
      sha256sum = "00e427d291e957462a8fad659a9f9c8be776ff82a8b76bdf402f1eaeec086d82",
    },
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
      drvs.libpng,
      drvs.expat,
      drvs.muslShared,
      # drvs.binutils,
      # drvs.lddObjdump,
      drvs.gobjectDynamic,
    ]
  }
}
