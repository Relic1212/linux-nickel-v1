{
  lib,
  drvs,
  gobjectIntrospection | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gobject-introspection/-/archive/1.84.0/gobject-introspection-1.84.0.tar.bz2",
      sha256sum = "8b943e6f8003619382b2d0540bf6a6eef8cab215d63ea5e070dd4fbc1a317d7e"
    },
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.pythonSetuptools,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNgPic,
      drvs.glib,
      (drvs.glibDynamic & { priority = -1 }),
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.libtool,
      drvs.cairo,
      drvs.pixman,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.muslShared,
      drvs.binutils,
      drvs.lddObjdump,
      drvs.gobjectDynamic,
    ],
  }
}
