{
  lib,
  drvs,
  socat | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://www.dest-unreach.org/socat/download/socat-1.8.0.3.tar.gz",
      sha256sum = "a9f9eb6cfb9aa6b1b4b8fe260edbac3f2c743f294db1e362b932eb3feca37ba4"
    },
    separateBuildDir = false,
    biDrvs = [
      drvs.pkgconf,
      drvs.openssl,
      drvs.linuxHeaders,
      drvs.ncurses,
    ],
    postInstallPhase = [
      # Bash
      "rm -rf ${DEST}/usr/bin/*.sh"
    ]
  }
}
