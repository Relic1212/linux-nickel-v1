{
  lib,

  utf8proc | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.9.0.tar.gz",
      sha256sum = "18c1626e9fc5a2e192311e36b3010bfc698078f692888940f1fa150547abb0c1"
    },
    extraMakeArgs = [
      "prefix=/usr"
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
