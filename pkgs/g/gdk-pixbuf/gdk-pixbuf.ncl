{
  lib,
  drvs,
  gdkPixbuf | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gdk-pixbuf/-/archive/2.42.12/gdk-pixbuf-2.42.12.tar.gz",
      sha256sum = "d41966831b3d291fcdfe31f683bea4b3f03241d591ddbe550b5db873af3da364",
    },
    pDrvs = [
      drvs.glib,
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.zlibNg
    ],
    extraMesonArgs = [
      "-Dgio_sniffing=false",
      "-Dinstalled_tests=false",
      "-Dtests=false",
      "-Dman=false",
      "-Dintrospection=disabled",
      "-Dgtk_doc=false",
      "-Dbuiltin_loaders=png,jpeg,gif",
      "-Djpeg=disabled",
      "-Dpng=disabled",
    ]
  }
}
& {
  lib,
  drvs,
  gdkPixbuf,
  gdkPixbufFull | lib.MesonPackage = {
    singleSource = gdkPixbuf.singleSource,
    buildEnv = {
      # _isStatic=false,
      EXTRA_LDFLAGS = ["-lpng", "-l:libjpeg.a"],
    },
    # isStatic=false,
    pDrvs = [
      drvs.glib,
      #drvs.muslShared,
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.zlibNg,
      drvs.libpng,
      drvs.libjpegTurbo,
    ],
    extraMesonArgs = [
      "-Dgio_sniffing=false",
      "-Dinstalled_tests=false",
      "-Dtests=false",
      "-Dman=false",
      "-Dintrospection=disabled",
      "-Dgtk_doc=false",
      "-Dbuiltin_loaders=png,jpeg,gif",
      "-Djpeg=enabled",
      "-Dpng=enabled",
    ]
  },

  gdkPixbufIntrospectionDynamic =
    gdkPixbufIntrospection
    & {
      isStatic = false,
    },
  gdkPixbufIntrospection | lib.MesonPackage = {
    singleSource = gdkPixbufFull.singleSource,
    buildEnv = gdkPixbufFull.buildEnv & { _isStatic = false },
    buildEnv.PKG_CONFIG = null,

    muslProvider = drvs.muslBoth,
    pythonProvider = drvs.pythonDynamic,

    extraMesonArgs = [
      "-Dgio_sniffing=false",
      "-Dinstalled_tests=false",
      "-Dtests=false",
      "-Dman=false",
      "-Dintrospection=enabled",
      "-Dgtk_doc=false",
      "-Dbuiltin_loaders=png,jpeg,gif",
      "-Djpeg=enabled",
      "-Dpng=enabled",
    ],

    biDrvs = [
      drvs.glibGobject,
      #drvs.muslShared,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.libpng,
      drvs.libjpegTurbo,
      drvs.gobjectDynamic,
      drvs.pythonSetuptools,
      drvs.ldd,
    ],
  }
}
& {
  lib,
  drvs,
  thorfdbgLibjpeg | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/thorfdbg/libjpeg/archive/c719010a26ce0c666e98b2acf924ad5fc24b4f5d.zip",
      sha256sum = "516366bb498c42fe1da5d2d6ea7998e029eb8ec19faaedec902a8d222554f582"
    },
    separateBuildDir = false,
    extraMakeInstallArgs = [
      "INSTALLDIR=${DEST}/usr"
    ]
  }
}
