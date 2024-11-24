{
  lib,
  drvs,
  jq | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz",
        sha256sum = "478c9ca129fd2e3443fe27314b455e211e0d8c60bc8ff7df703873deeee580c2"
      },
      #separateBuildDir = false,
    }
}
