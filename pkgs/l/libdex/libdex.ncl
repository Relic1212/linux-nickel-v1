{
  lib,
  drvs,
  libdex | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/libdex/-/archive/1.2.0/libdex-1.2.0.tar.bz2",
      sha256sum = "0b3b12403ddeac30e5a18ba84010099e2986c07547cc714aeb7ed3b5de40c60c",
    },

    extraMesonArgs = [
      "-Dexamples=false",
      "-Dvapi=false",
      "-Dintrospection=disabled",
      "-Dtests=false",
      "-Dpygobject=false",
    ],

    biDrvs = [
      drvs.libemptyAtomic,
      drvs.libempty,
    ],
    pDrvs = [
      drvs.glib,
    ],
  }
}
