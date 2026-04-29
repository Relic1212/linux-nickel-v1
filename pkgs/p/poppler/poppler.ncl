{
  lib,
  drvs,
  poppler | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://poppler.freedesktop.org/poppler-26.04.0.tar.xz",
      sha256sum = "b0955163114af96bc0106f68cb24daf973a629462453d8b82775f81b0d4e0693",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static expat pixman-1)",
      ],
    },

    cmakeExtraArgsRecord = {
      "-DENABLE_NSS3" = false,
      "-DENABLE_GOBJECT_INTROSPECTION" = false,
      "-DENABLE_GTK_DOC" = false,
      "-DENABLE_QT5" = false,
      "-DENABLE_QT6" = false,
      "-DENABLE_LIBOPENJPEG" = "none",
      "-DENABLE_GPGME" = false,
      "-DENABLE_GLIB" = true,
    },
    biDrvs = [
      drvs.zlibNg,
      drvs.freetype,
      drvs.gperf,
      drvs.expat,
      drvs.fontconfig,
      drvs.libtiff,
      #   drvs.libassuan,
      #   drvs.libgpgError,
      #   drvs.gpgme,
      drvs.lcms,
      drvs.openssl,
      drvs.libpsl,
      drvs.perl,
      drvs.curl,
      drvs.libjpegTurboStatic,
      drvs.bzip2,
      drvs.zstd,
      drvs.xz,
      drvs.boost,
      drvs.pcre2,
      drvs.libffi,
      drvs.glib,
      drvs.pixman,
      drvs.libpng,
      drvs.cairo,
      drvs.pythonFull,
    ]
  }
}
