{
  lib,
  drvs,
  libroco | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.13.tar.xz",
      sha256sum = "767ec234ae7aa684695b3a735548224888132e063f92db585759b422570621d4",
    },
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      #   EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },
    biDrvs = [
      drvs.pkgconfMeson,
    ],
    pDrvs = [
      drvs.glib,
      drvs.libxml2,
    ]
  }
}
