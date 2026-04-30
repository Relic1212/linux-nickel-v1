{
  lib,
  drvs,
  graphene | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources//graphene/1.10/graphene-1.10.8.tar.xz",
      sha256sum = "a37bb0e78a419dcbeaa9c7027bcff52f5ec2367c25ec859da31dfde2928f279a"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
    ],
  },
  grapheneIntrospection | lib.MesonPackage = {
    singleSource = graphene.singleSource,
    extraMesonArgs = [
      "-Dintrospection=enabled",
    ],
    pythonProvider = drvs.pythonDynamic,
    buildEnv._isStatic = false,
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glibGobject,
      drvs.gobjectDynamic,
      drvs.pythonSetuptools,
      drvs.muslShared & { priority = -1 },
      drvs.ldd,
    ],
  }
}
