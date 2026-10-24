{
  lib,
  drvs,
  gnomeAutoar | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gnome-autoar/-/archive/0.4.5/gnome-autoar-0.4.5.tar.bz2?ref_type=tags",
      sha256sum = "d0fc83b5a09ed00ae192f90367485509b3d3d2002e8400de05680bd4e1543a67",
    },
    extraMesonArgs = [
      "-Dgtk=false",
      "-Dintrospection=disabled",
      "-Dvapi=false",
    ],
    preConfigurePhase = [
      m%"sed -i 's|shared_library|library|g' ${SRC}/gnome-autoar/meson.build"%,
    ],

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.libarchive,
      drvs.glib,
    ]
  }
}
