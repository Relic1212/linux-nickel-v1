{
  lib,
  drvs,
  zzz | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/jirutka/zzz/archive/refs/tags/v0.2.0.tar.gz",
      sha256sum = "1efb41967535ab6d67fd1d343c0eb6121c8d9261697962af29adaa2dbbf1b51c"
    },
    makeTargets = [
      "build-exec"
    ],
    makeInstallTargets = [
      "install-conf",
      "install-exec"
    ],
    extraMakeArgs = [
      "prefix=/usr",
      "sbindir=/usr/bin",
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
