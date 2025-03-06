{
  lib,
  drvs,
  libyaml | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/yaml/libyaml/archive/840b65c40675e2d06bf40405ad3f12dec7f35923.zip",
      sha256sum = "269a8f5805b73ed7e90303eec20687ff2bfcdd29157b470c92d18eeb45c53d85"
    }
  }
}
