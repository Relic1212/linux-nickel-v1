{
  lib,
  drvs,
  jansson | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/akheron/jansson/releases/download/v2.14.1/jansson-2.14.1.tar.gz",
      sha256sum = "2521cd51a9641d7a4e457f7215a4cd5bb176f690bc11715ddeec483e85d9e2b3"
    }
  }
}
