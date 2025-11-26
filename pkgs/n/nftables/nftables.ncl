{
  lib,
  drvs,
  nftables | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.netfilter.org/projects/nftables/files/nftables-1.1.5.tar.xz",
      sha256sum = "1daf10f322e14fd90a017538aaf2c034d7cc1eb1cc418ded47445d714ea168d4",
    },
    extraEnv.LIBS = [
      "-lncurses",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libmnl,
      drvs.pkgconfMeson,
      drvs.libnftnl,
      drvs.gmp,
      drvs.libedit,
      drvs.ncurses,
    ],
  }
}
