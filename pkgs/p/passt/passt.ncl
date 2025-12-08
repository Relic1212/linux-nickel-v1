{
  lib,
  drvs,
  passt | lib.MakePackage = {
    singleSource = {
      uri = "https://passt.top/passt/snapshot/passt-2025_09_19.623dbf6.tar.bz2",
      sha256sum = "4e4f1b6734425f247c1121e03f6f369b9bf42fbaeb16ee8dd0f56d94c8be5b2a"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.coreutils & { priority = -1 }, # fmt
      drvs.sbase & { priority = -1 }, # getconf
    ],

    extraMakeArgs = [
      "prefix=/usr",
    ],

    extraMakeInstallArgs = extraMakeArgs,
  }
}
