{
  lib,
  drvs,
  libqalculate | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/Qalculate/libqalculate/archive/refs/tags/v5.10.0.tar.gz",
      sha256sum = "0053d1d12361bb07bb8117c2b7fb8df7abc70f73d7346b2fe8731525cb6709fd",
    },
    # buildEnv.CC=["cc"],
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
    },
    extraEnv = {
      LDFLAGS_FOR_BUILD = ["-static", "--static", ],
    },
    biDrvs = [
      drvs.gettext,
      # drvs.clangCC,
    ],
    pDrvs = [
      drvs.gmp,
      drvs.mpfr,
      drvs.libicu,
      drvs.libxml2,
      #   drvs.libpsl,
      drvs.curl,
      #   drvs.openssl,
      #   drvs.zlibNg,
    ]
  }
}
