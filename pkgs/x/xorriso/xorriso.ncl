{
  lib,
  drvs,
  xorriso | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.gnu.org/software/xorriso/xorriso-1.5.6.pl02.tar.gz",
      sha256sum = "786f9f5df9865cc5b0c1fecee3d2c0f5e04cab8c9a859bd1c9c7ccd4964fdae1"
    },
    biDrvs = [
      drvs.linuxHeaders
    ]
  }
}
