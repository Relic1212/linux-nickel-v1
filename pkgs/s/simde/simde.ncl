{
  lib,
  drvs,
  simde | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/simd-everywhere/simde/archive/refs/tags/v0.8.2.tar.gz",
      sha256sum = "ed2a3268658f2f2a9b5367628a85ccd4cf9516460ed8604eed369653d49b25fb"
    },
    extraMesonArgs = [
      "-Dtests=false"
    ]
  }
}
