{
  lib,
  drvs,
  libscfg | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/emersion/libscfg/archive/v0.2.0.tar.gz",
      sha256sum = "cf37ef00ac8efb28821dac1ad49e2c6b23b242d9d961fab6fcda72fc73a7291b"
    },
  }
}
