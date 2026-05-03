{
  lib,
  drvs,
  tlp | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/linrunner/TLP/archive/refs/tags/1.10.0.tar.gz",
      sha256sum = "902d9be64746e0d9b9c879b963b2b90a2d3edd265ee192db76d692c5a962a3ff"
    },
    extraMakeArgs = [
      "TLP_SBIN=/usr/bin",
    ],
    extraMakeInstallArgs = extraMakeArgs
  }
}
