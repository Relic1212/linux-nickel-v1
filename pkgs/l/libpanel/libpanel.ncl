{
  lib,
  drvs,
  libpanel | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/libpanel/-/archive/1.10.4/libpanel-1.10.4.tar.bz2",
      sha256sum = "3c0656f987b770bef09a18a68d6612b2bb415f8ecce63eecad1662a0b3fba00f",
    },

    extraMesonArgs = [
      "-Dintrospection=disabled",
      "-Ddocs=disabled",
      "-Dvapi=false",
    ],

    llvmProvider = drvs.llvmFull,
    pDrvs = [
      drvs.libadwaita,
    ],
  }
}
