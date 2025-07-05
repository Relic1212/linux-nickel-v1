{
  lib,
  drvs,
  nettle | lib.AutotoolsPackage =
    let _nettle | lib.AutotoolsPackage = {
      name = "nettle",
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/nettle/nettle-3.10.tar.gz",
        sha256sum = "b4c518adb174e484cb4acea54118f02380c7133771e7e9beb98a0787194ee47c",
      },

      biDrvs = [
        drvs.m4
      ],
    }
    in _nettle
}
