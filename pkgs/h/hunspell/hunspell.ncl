{
  lib,
  drvs,
  hunspell | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/hunspell/hunspell/archive/refs/tags/v1.7.2.tar.gz",
      sha256sum = "69fa312d3586c988789266eaf7ffc9861d9f6396c31fc930a014d551b59bbd6e",
    },
    biDrvs = [
      drvs.gettext,
    ]
  }
}
