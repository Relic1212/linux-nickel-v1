{
  lib,
  drvs,
  libnftnl | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.netfilter.org/projects/libnftnl/files/libnftnl-1.3.0.tar.xz",
      sha256sum = "0f4be47a8bb8b77a350ee58cbd4b5fae6260ad486a527706ab15cfe1dd55a3c4"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libmnl,
      drvs.pkgconfMeson,
    ]
  }
}
