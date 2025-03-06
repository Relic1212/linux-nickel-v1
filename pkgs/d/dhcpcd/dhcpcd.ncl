{
  lib,
  pkgs,
  dhcpcd | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/NetworkConfiguration/dhcpcd/releases/download/v10.0.10/dhcpcd-10.0.10.tar.xz",
      sha256sum = "d582012992efddd2442bb1213c518a37d90febbcf8b11f8e76448c710dacad27",
    },
    buildDir = "${SRC}",
    extraConfigureFlags = [
      "--dbdir=/var/lib/dhcpcd",
      "--rundir=/run/dhcpcd",
      "--runstatedir=/run/dhcpcd"
    ],
    biDrvs =
      lib.biMap [
        pkgs.linuxHeaders,
      ]
  }
}
