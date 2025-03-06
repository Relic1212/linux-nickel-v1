{
  lib,
  drvs,
  gdkPixbuf | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gdk-pixbuf/-/archive/2.42.12/gdk-pixbuf-2.42.12.tar.gz",
      sha256sum = "d41966831b3d291fcdfe31f683bea4b3f03241d591ddbe550b5db873af3da364",
    },
    biDrvs = [
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg
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
  gdkPixbufFull | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gdk-pixbuf/-/archive/2.42.12/gdk-pixbuf-2.42.12.tar.gz",
      sha256sum = "d41966831b3d291fcdfe31f683bea4b3f03241d591ddbe550b5db873af3da364",
    },

    buildEnv = {
      # _isStatic=false,
      EXTRA_LDFLAGS = ["-lpng", "-l:libjpeg.a"],
    },
    # isStatic=false,
    biDrvs = [
      drvs.glib,
      #drvs.muslShared,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
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
& {
  lib,
  drvs,
  libjpegTurbo | lib.CmakePackage = {
    buildEnv._isStatic = false,
    isStatic = false,
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.0.4.tar.gz",
      sha256sum = "0270f9496ad6d69e743f1e7b9e3e9398f5b4d606b6a47744df4b73df50f62e38"
    },
    biDrvs = [
      drvs.muslShared,
    ]
  }
}
& {
  lib,
  drvs,
  libjpegTurbo,
  libjpegTurboStatic | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = libjpegTurbo.singleSource,
    biDrvs = [],
    cmakeExtraArgsRecord = {
      "-DENABLE_SHARED" = false,
    }
  }
}
