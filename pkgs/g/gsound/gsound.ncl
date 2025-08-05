{
  lib,
  drvs,
  gsound | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gsound/-/archive/1.0.3/gsound-1.0.3.tar.gz",
      sha256sum = "ebee33c77f43bcae87406c20e051acaff08e86f8960c35b92911e243fddc7a0b"
    },

    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.vala,
      drvs.libcanberra,
      drvs.libogg,
      drvs.libvorbis,
      drvs.alsaLibs,
      drvs.eudev,

      drvs.gperf,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,

    ],
    extraMesonArgs = [
      "-Dgtk_doc=false",
      "-Dintrospection=false",
      "-Denable_vala=false",
    ]
  }
}