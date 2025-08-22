{
  lib,
  drvs,
  keyd | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/rvaiya/keyd/archive/refs/tags/v2.5.0.tar.gz",
      sha256sum = "93ec6c153ef673a7a8b4d8b686494dee11d182513f4531c71dce15a8db7f6c1c"
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    biDrvs = [
      drvs.linuxHeaders
    ]
  }
}
