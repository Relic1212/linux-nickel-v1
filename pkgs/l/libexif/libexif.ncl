{
  lib,
  drvs,
  libexif | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/libexif/libexif/archive/refs/tags/v0.6.25.tar.gz",
      sha256sum = "b23af41f37019b8d591d4d9b42ba52fd30709b6767341aa887f9afe400c8408a",
    },
    biDrvs = [
      drvs.gettext,
    ]
  }
}
