{
  lib,
  drvs,
  gnutls | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.11.tar.xz",
      sha256sum = "90e337504031ef7d3077ab1a52ca8bac9b2f72bc454c95365a1cd1e0e81e06e9"
    },
    extraConfigureFlags = [
      "--with-included-unistring",
      # "--without-p11-kit",
      # "--with-default-trust-store-pkcs11=\"pkcs11\"",
      "--with-default-trust-store-file=/etc/ssl/cert.pem",
    ],

    preConfigurePhase =
      std.array.map
        (fun s => "sed -i 's|getprogname |gnutls_getprogname |g' ${SRC}/%{s}")
        [
          "src/gl/error.c",
          "src/gl/getprogname.c",
          "src/gl/tests/test-getprogname.c",
          "src/gl/getprogname.h",
        ],

    biDrvs = [
      #   (drvs.libffi & { priority = 2}),
      #   drvs.glib,
      #   drvs.gnupg2,
      #   drvs.gpgme,
      #   drvs.libassuan,
      #   drvs.libgcrypt,
      #   drvs.libgpgError,
      #   drvs.libxslt,
      #   drvs.openssl,
      #   drvs.p11Kit,
      #   drvs.pcre2,
      #   drvs.zlibNg,
      # drvs.gmp,
      # drvs.libtasn1,
      drvs.linuxHeaders,
      drvs.m4,
      # drvs.nettleGmp,
      drvs.pkgconfMeson,
    ],
    pDrvs = [
      # drvs.libtasn1,
      drvs.nettleGmp,
      drvs.p11Kit,
    ]
  },

  # gnutlsWithTrust | lib.AutotoolsPackage= gnutls & {
  #    pDrvs | priority 1= [
  #     drvs.libtasn1,
  #     drvs.nettleGmp,
  #     drvs.p11Kit,
  #   ]
  # }

  libtasn1 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz",
      sha256sum = "92e0e3bd4c02d4aeee76036b2ddd83f0c732ba4cda5cb71d583272b23587a76c",
    }
  }
}
