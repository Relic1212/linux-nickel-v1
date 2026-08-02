{
  lib,
  drvs,
  gdb | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/gdb/gdb-17.2.tar.xz",
      sha256sum = "1c036c0d72e4b3d1fb5c94c88632add6f9d76f4d7c4d2ea793c12a9f19a3228c",
    },
    extraConfigureFlags = [
      "--with-static-standard-libraries",
      "--disable-host-shared",
      "--disable-libdiagnostics",
      "--disable-inprocess-agent",
    ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.mpfr,
      drvs.gmp,
      drvs.readline,
    ]
  }
}
