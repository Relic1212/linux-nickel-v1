{
  lib,

  tlp | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/linrunner/TLP/archive/refs/tags/1.7.0.tar.gz",
      sha256sum = "547ff90bef0ea035f0ff6d7546d0d867690ebf60beec426885a884ee8d023e2e"
    },
    extraMakeArgs = [
      "TLP_SBIN=/usr/bin",
    ],
    extraMakeInstallArgs = extraMakeArgs
  }
}
