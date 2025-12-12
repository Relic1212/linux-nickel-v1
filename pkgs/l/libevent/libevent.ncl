{
  lib,
  drvs,
  libevent | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz",
      sha256sum = "92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb"
    },
    biDrvs = [
      drvs.openssl,
      drvs.pkgconfMeson,
    ]
  }
}
