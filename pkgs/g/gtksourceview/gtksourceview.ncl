{
  lib,
  drvs,
  gtksourceview | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gtksourceview/-/archive/5.20.0/gtksourceview-5.20.0.tar.bz2",
      sha256sum = "baf9d4dd98a8611aab00be77d511aebaca0c63a00d9c9abb2d80164e5ac317ac",
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
    },
    extraMesonArgs = [
      "-Dbuild-testsuite=false",
      "-Dvapi=false",
      "-Dintrospection=disabled"
    ],
    llvmProvider = drvs.llvmFull,
    neverInclude = [
      drvs.harfbuzz,
    ],
    pDrvs = [
      drvs.gtk4,
      drvs.libxml2,
    ],
  }
}
