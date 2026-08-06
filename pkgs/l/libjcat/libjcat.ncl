{
  lib,
  drvs,
  libjcat | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/hughsie/libjcat/archive/refs/tags/0.2.5.tar.gz",
      sha256sum = "4ea337d99744bff98e8eba46de7ee3fdf2d721bdf3737e95500ba32192b84463"
    },
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvapi=false",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lassuan"
      ]
    },
    biDrvs = [
      drvs.jsonGlib,
      # drvs.gmp,
      # drvs.libtasn1,
      # drvs.nettleGmp,
      # drvs.gnutls,
      # drvs.libassuan,
      # drvs.libgcrypt,
      # drvs.libgpgError,
      # drvs.gpgme,
    ],
    pDrvs = [
      drvs.gnutls,
      # drvs.glib,
    ]
  }
}
