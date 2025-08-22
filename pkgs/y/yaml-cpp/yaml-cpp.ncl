{
  lib,
  drvs,
  yamlCpp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz",
      sha256sum = "fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16"
    },

    biDrvs = [
      drvs.libyaml,
    ]
  }
}
