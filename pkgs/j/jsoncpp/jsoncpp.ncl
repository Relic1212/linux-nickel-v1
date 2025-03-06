{
  lib,
  drvs,
  jsoncpp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.9.6.tar.gz",
      sha256sum = "f93b6dd7ce796b13d02c108bc9f79812245a82e577581c4c9aabe57075c90ea2"
    }
  }
}
