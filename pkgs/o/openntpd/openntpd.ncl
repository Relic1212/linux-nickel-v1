{
  lib,
  drvs,
  openntpd | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://cdn.openbsd.org/pub/OpenBSD/OpenNTPD/openntpd-6.8p1.tar.gz",
      sha256sum = "8582db838a399153d4a17f2a76518b638cc3020f58028575bf54127518f55a46",
    },
    extraConfigureFlags = [
      "ac_cv_libc_defines___progname=\"yes\"",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
  }
}
