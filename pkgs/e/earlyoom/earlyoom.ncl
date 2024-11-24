{
  lib,
  drvs,
  earlyoom | lib.MakePackage
    = {
      singleSource = {
        uri = "https://github.com/rfjakob/earlyoom/archive/refs/tags/v1.8.2.tar.gz",
        sha256sum = "13869413dc0d973e454854077be7a2049d350f77a97f6911b654e88dc4b20346"
      },
      extraMakeInstallArgs = [
        "PREFIX=/usr"
      ]
    }
}
