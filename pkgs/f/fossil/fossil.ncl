{
  lib,
  drvs,
  fossil | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.fossil-scm.org/home/tarball/f3c2b9a29e540d1102ecc10fdc77b64fdd1c9c19c9f6ce5b5c271fe4ecf1da79/fossil-src-202601281614.tar.gz",
      sha256sum = "099521fe4a71fde7cdcab1eecb18a11580f6757a4c9647f6d258aaefc05de963",
    },
    buildEnv = {
      #   CC = ["clang", "-static","--static"],
      CC = extraEnv.CC_FOR_BUILD,
    },
    extraEnv = {
      #   CC_FOR_BUILD = ["clang", "--verbose","-static","--static"],
      CC_FOR_BUILD = "static-clang",
    },
    configureFlags = [
      "--static",
      "--prefix=/usr",
    ],
    biDrvs = [
      drvs.clangStatic,
      drvs.pkgconfMeson,
    ],
    pDrvs = [
      drvs.zlibNg,
      drvs.openssl,
    ]
  }
}
